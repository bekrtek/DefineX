//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import Foundation
import FirebaseAnalytics

enum AnalyticsEvent {
    case login(success: Bool)
    case viewScreen(name: String)
    case buttonTap(name: String)
    case error(description: String)
    
    var name: String {
        switch self {
        case .login:
            return "login_attempt"
        case .viewScreen:
            return "screen_view"
        case .buttonTap:
            return "button_tap"
        case .error:
            return "error_occurred"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .login(let success):
            return ["success": success]
        case .viewScreen(let name):
            return ["screen_name": name]
        case .buttonTap(let name):
            return ["button_name": name]
        case .error(let description):
            return ["error_description": description]
        }
    }
}

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    func logEvent(_ event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
    
    func setUserProperty(_ value: String?, forName name: String) {
        Analytics.setUserProperty(value, forName: name)
    }
} 
