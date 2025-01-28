import Foundation
import UIKit
import Firebase
import FirebaseCrashlytics

final class ApplicationManager {
    static let shared = ApplicationManager()
    
    private init() {}
    
    // MARK: - Properties
    private let userManager: UserManager = .shared
    private let keychainManager: KeychainManager = .shared
    private let networkManager: NetworkManager = .shared
    private let cacheManager: CacheManager = .shared
    
    // MARK: - Public Methods
    func configure() {
        setupInitialState()
        setupFirebase()
    }
    
    // MARK: - Private Methods
    private func setupInitialState() {
        setupAppearance()
    }
    
    private func setupAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        setupCrashReporting()
    }
    
    private func setupCrashReporting() {
        Crashlytics.crashlytics().setCustomKeysAndValues([
            "app_version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
            "build_number": Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "",
            "device_model": UIDevice.current.model,
            "os_version": UIDevice.current.systemVersion
        ])
    }
} 
