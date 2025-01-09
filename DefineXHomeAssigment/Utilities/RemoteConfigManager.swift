//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import Foundation
import FirebaseRemoteConfig

enum RemoteConfigKey: String {
    case welcomeMessage = "welcome_message"
    case isFeatureEnabled = "is_feature_enabled"
    // Add more keys as needed
}

final class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    private let remoteConfig: RemoteConfig
    
    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0 // For development
        remoteConfig.configSettings = settings
        
        // Default values
        remoteConfig.setDefaults([
            RemoteConfigKey.welcomeMessage.rawValue: "Welcome to DefineX" as NSObject,
            RemoteConfigKey.isFeatureEnabled.rawValue: false as NSObject
        ])
    }
    
    func fetchConfig(completion: @escaping (Error?) -> Void) {
        remoteConfig.fetch { [weak self] status, error in
            if status == .success {
                self?.remoteConfig.activate { _, error in
                    completion(error)
                }
            } else {
                completion(error)
            }
        }
    }
    
    func getString(for key: RemoteConfigKey) -> String {
        return remoteConfig[key.rawValue].stringValue
    }
    
    func getBool(for key: RemoteConfigKey) -> Bool {
        return remoteConfig[key.rawValue].boolValue
    }
    
    func getNumber(for key: RemoteConfigKey) -> NSNumber {
        return remoteConfig[key.rawValue].numberValue
    }
} 
