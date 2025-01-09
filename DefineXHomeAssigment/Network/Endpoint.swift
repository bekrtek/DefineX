//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: [String: Any]? { get }
}

enum LoginEndpoint: Endpoint {
    case login(email: String, password: String)
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var body: [String: Any]? {
        switch self {
        case .login(let email, let password):
            return [
                "email": email,
                "password": password
            ]
        }
    }
}

enum DiscoveryEndpoint: Endpoint {
    case firstHorizontalList
    case secondHorizontalList
    case thirdTwoColumnList
    
    var path: String {
        switch self {
        case .firstHorizontalList:
            return "/discoverFirstHorizontalList"
        case .secondHorizontalList:
            return "/discoverSecondHorizontalList"
        case .thirdTwoColumnList:
            return "/discoverThirthTwoColumnList"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String: String]? {
        let cachedResponse: LoginResponse? = try? CacheManager.shared.load(forKey: CacheManager.CacheKey.userToken)
        var headers = ["Content-Type": "application/json"]
        
        if let loginResponse = cachedResponse {
            headers["token"] = "\(loginResponse.token)"
        }
        
        return headers
    }
    
    var body: [String: Any]? {
        return nil
    }
} 
