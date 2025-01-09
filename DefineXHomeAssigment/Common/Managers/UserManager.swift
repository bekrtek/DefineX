//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import Foundation
import Security

final class UserManager {
    // MARK: - Properties
    static let shared = UserManager()
    private let keychain = KeychainManager.shared
    private let defaults = UserDefaults.standard
    
    private let tokenKey = "user_token"
    private let emailKey = "user_email"
    private let isLoggedInKey = "is_logged_in"
    
    private(set) var currentToken: String? {
        get {
            try? keychain.get(tokenKey)
        }
        set {
            if let token = newValue {
                try? keychain.save(token, for: tokenKey)
            } else {
                try? keychain.delete(tokenKey)
            }
        }
    }
    
    var isLoggedIn: Bool {
        get {
            defaults.bool(forKey: isLoggedInKey)
        }
        set {
            defaults.set(newValue, forKey: isLoggedInKey)
        }
    }
    
    var userEmail: String? {
        get {
            defaults.string(forKey: emailKey)
        }
        set {
            defaults.set(newValue, forKey: emailKey)
        }
    }
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Public Methods
    func login(with token: String, email: String) {
        currentToken = token
        userEmail = email
        isLoggedIn = true
    }
    
    func logout() {
        currentToken = nil
        userEmail = nil
        isLoggedIn = false
    }
    
    func validateSession() -> Bool {
        guard isLoggedIn, currentToken != nil else {
            logout()
            return false
        }
        return true
    }
}

