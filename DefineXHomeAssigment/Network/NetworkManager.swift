//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case unauthorized
    case unknown
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.noData, .noData),
             (.decodingError, .decodingError),
             (.unauthorized, .unauthorized),
             (.unknown, .unknown):
            return true
        case (.serverError(let lhsMessage), .serverError(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

protocol NetworkManagerProtocol: AnyObject {
    func request<T: Codable>(endpoint: Endpoint, responseType: T.Type, useCache: Bool, completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    // MARK: - Properties
    static let shared = NetworkManager()
    private let baseURL = "https://teamdefinex-mobile-auth-casestudy.vercel.app"
    private let cacheManager: CacheManagerProtocol
    private let queue = DispatchQueue(label: "com.definex.networkmanager", attributes: .concurrent)
    private let urlSession: URLSession
    
    // MARK: - Initialization
    init(cacheManager: CacheManagerProtocol = CacheManager.shared, urlSession: URLSession = .shared) {
        self.cacheManager = cacheManager
        self.urlSession = urlSession
    }
    
    // MARK: - NetworkManagerProtocol
    func request<T: Codable>(endpoint: Endpoint, responseType: T.Type, useCache: Bool = true, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let cacheKey = "\(endpoint.path)_\(endpoint.method.rawValue)"
        
        print("🌐 Network Request:")
        print("📍 URL: \(baseURL + endpoint.path)")
        print("📝 Method: \(endpoint.method.rawValue)")
        print("🔑 Headers: \(endpoint.headers ?? [:])")
        if let body = endpoint.body {
            print("📦 Body: \(body)")
        }
        
        if useCache {
            queue.async { [weak self] in
                guard let self = self else { return }
                do {
                    let cachedData: T = try self.cacheManager.load(forKey: cacheKey)
                    print("📦 Using cached data for: \(cacheKey)")
                    DispatchQueue.main.async {
                        completion(.success(cachedData))
                    }
                } catch {
                    print("❌ Cache miss for: \(cacheKey)")
                    self.makeNetworkRequest(endpoint: endpoint, responseType: responseType, cacheKey: cacheKey, completion: completion)
                }
            }
        } else {
            makeNetworkRequest(endpoint: endpoint, responseType: responseType, cacheKey: cacheKey, completion: completion)
        }
    }
    
    // MARK: - Private Methods
    private func makeNetworkRequest<T: Codable>(endpoint: Endpoint, responseType: T.Type, cacheKey: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: baseURL + endpoint.path) else {
            print("❌ Invalid URL: \(baseURL + endpoint.path)")
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            print("📥 Response received for: \(url.absoluteString)")
            
            if let error = error {
                print("❌ Network Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(.unknown))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("❌ Invalid response type")
                DispatchQueue.main.async {
                    completion(.failure(.unknown))
                }
                return
            }
            
            print("📊 Status Code: \(response.statusCode)")
            
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                print("📦 Response Data: \(jsonString)")
            }
            
            switch response.statusCode {
            case 200...299:
                guard let data = data else {
                    print("❌ No data received")
                    DispatchQueue.main.async {
                        completion(.failure(.noData))
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    print("✅ Successfully decoded response")
                    
                    
                    if endpoint.method == .get {
                        self?.queue.async {
                            try? self?.cacheManager.save(result, forKey: cacheKey)
                            print("💾 Response cached for: \(cacheKey)")
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch {
                    print("❌ Decoding Error: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                    }
                }
            case 401:
                print("🔒 Unauthorized access")
                DispatchQueue.main.async {
                    completion(.failure(.unauthorized))
                }
            default:
                print("❌ Server Error: Status code \(response.statusCode)")
                DispatchQueue.main.async {
                    completion(.failure(.serverError("Status code: \(response.statusCode)")))
                }
            }
        }
        task.resume()
    }
} 
