//
//  AppDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import UIKit
import Firebase
import FirebaseCrashlytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Setup window first for faster launch
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()
        
        // Configure Firebase after window is shown
        DispatchQueue.main.async {
            // Configure Firebase
            FirebaseApp.configure()
            
            // Configure Crashlytics
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
            self.setupCrashReporting()
        }
        
        return true
    }
}

// MARK: - Crash Reporting
extension AppDelegate {
    func setupCrashReporting() {
        // Set user ID for crash reports
        if let userToken = try? CacheManager.shared.load(forKey: CacheManager.CacheKey.userToken) as LoginResponse {
            Crashlytics.crashlytics().setUserID(userToken.token)
        }
        
        // Set custom keys
        Crashlytics.crashlytics().setCustomKeysAndValues([
            "app_version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
            "build_number": Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "",
            "device_model": UIDevice.current.model,
            "os_version": UIDevice.current.systemVersion
        ])
    }
}

