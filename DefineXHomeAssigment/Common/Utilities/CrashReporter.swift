//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import Foundation
import FirebaseCrashlytics

final class CrashReporter {
    // MARK: - Properties
    static let shared = CrashReporter()
    private let crashlytics = Crashlytics.crashlytics()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Public Methods
    func setUserIdentifier(_ identifier: String) {
        crashlytics.setUserID(identifier)
    }
    
    func log(error: Error) {
        crashlytics.record(error: error)
    }
    
    func log(message: String) {
        crashlytics.log(message)
    }
    
    func setCustomValue(_ value: Any, forKey key: String) {
        crashlytics.setCustomValue(value, forKey: key)
    }
    
    func setCustomKeysAndValues(_ keysAndValues: [String: Any]) {
        crashlytics.setCustomKeysAndValues(keysAndValues)
    }
} 
