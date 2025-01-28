//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import Foundation

enum CacheError: Error {
    case invalidData
    case saveFailed
    case loadFailed
    case notFound
}

protocol CacheManagerProtocol {
    func save<T: Codable>(_ object: T, forKey key: String) throws
    func load<T: Codable>(forKey key: String) throws -> T
}

final class CacheManager: CacheManagerProtocol {
    // MARK: - Properties
    static let shared = CacheManager()
    static let userToken = "user_token"
    
    private let memoryCache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
   
    
    // MARK: - Initialization
    private init() {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = urls[0].appendingPathComponent("AppCache")
        
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        
        // Configure memory cache
        memoryCache.countLimit = 100 // Maximum number of items
        memoryCache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }
    
    // MARK: - Private Methods
    private func fileURL(forKey key: String) -> URL {
        return cacheDirectory.appendingPathComponent(key)
    }
    
    // MARK: - CacheManagerProtocol
    func save<T: Codable>(_ object: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(object)
        
        // Save to memory cache
        memoryCache.setObject(data as NSData, forKey: key as NSString)
        
        // Save to disk
        let fileURL = self.fileURL(forKey: key)
        try data.write(to: fileURL, options: .atomic)
    }
    
    func load<T: Codable>(forKey key: String) throws -> T {
        // Try memory cache first
        if let cachedData = memoryCache.object(forKey: key as NSString) {
            let object = try JSONDecoder().decode(T.self, from: cachedData as Data)
            return object
        }
        
        // Try disk cache
        let fileURL = self.fileURL(forKey: key)
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw CacheError.notFound
        }
        
        guard let data = try? Data(contentsOf: fileURL) else {
            throw CacheError.loadFailed
        }
        
        let object = try JSONDecoder().decode(T.self, from: data)
        
        // Save to memory cache for next time
        memoryCache.setObject(data as NSData, forKey: key as NSString)
        
        return object
    }
} 
