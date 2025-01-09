//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import Foundation

extension CacheManager {
    enum CacheKey {
        static let userToken = "user_token"
        static let firstHorizontalList = "/discoverFirstHorizontalList_GET"
        static let secondHorizontalList = "/discoverSecondHorizontalList_GET"
        static let thirdTwoColumnList = "/discoverThirthTwoColumnList_GET"
    }
    
    func clearUserData() {
        remove(forKey: CacheKey.userToken)
    }
    
    func clearDiscoveryData() {
        remove(forKey: CacheKey.firstHorizontalList)
        remove(forKey: CacheKey.secondHorizontalList)
        remove(forKey: CacheKey.thirdTwoColumnList)
    }
} 
