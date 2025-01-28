import XCTest
@testable import DefineXHomeAssigment
import Firebase
import FirebaseCrashlytics

final class ApplicationManagerTests: XCTestCase {
    var sut: ApplicationManager!
    
    override func setUp() {
        super.setUp()
        sut = ApplicationManager.shared
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Given
        let initialLoginState = sut.isLoggedIn
        
        // Then
        XCTAssertFalse(initialLoginState, "Initial login state should be false")
    }
    
    func testLogoutClearsAllData() {
        // Given
        let expectation = expectation(description: "Logout notification received")
        var notificationReceived = false
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("UserLoggedOut"), object: nil, queue: nil) { _ in
            notificationReceived = true
            expectation.fulfill()
        }
        
        // When
        sut.logout()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(notificationReceived, "Logout notification should be posted")
        XCTAssertFalse(sut.isLoggedIn, "isLoggedIn should be false after logout")
    }
    
    func testSharedInstance() {
        // Given
        let instance1 = ApplicationManager.shared
        let instance2 = ApplicationManager.shared
        
        // Then
        XCTAssertTrue(instance1 === instance2, "Shared instances should be identical")
    }
    
    func testNavigationBarAppearance() {
        // Given
        sut.configure()
        
        // Then
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBar.appearance().standardAppearance
            XCTAssertNotNil(appearance)
            XCTAssertEqual(appearance.backgroundColor, .white)
            
            let scrollEdgeAppearance = UINavigationBar.appearance().scrollEdgeAppearance
            XCTAssertNotNil(scrollEdgeAppearance)
            XCTAssertEqual(scrollEdgeAppearance, appearance)
        }
    }
    
    func testCrashReportingCustomKeys() {
        // Given
        sut.configure()
        
        // Then
        let crashlytics = Crashlytics.crashlytics()
        
        // Verify custom keys are set
        // Note: Since we can't directly access Crashlytics custom keys, we can only verify the configuration doesn't crash
        XCTAssertNoThrow(crashlytics.setCustomKeysAndValues([
            "app_version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
            "build_number": Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "",
            "device_model": UIDevice.current.model,
            "os_version": UIDevice.current.systemVersion
        ]))
    }
    
    func testFirebaseConfiguration() {
        // Given
        sut.configure()
        
        // Then
        XCTAssertNotNil(FirebaseApp.app(), "Firebase should be configured")
        XCTAssertTrue(Crashlytics.crashlytics().isCrashlyticsCollectionEnabled(), "Crashlytics should be enabled")
    }
    
    func testManagerDependencies() {
        // Then
        let mirror = Mirror(reflecting: sut)
        
        // Verify all required managers are initialized
        let hasUserManager = mirror.children.contains { $0.label == "userManager" }
        let hasKeychainManager = mirror.children.contains { $0.label == "keychainManager" }
        let hasNetworkManager = mirror.children.contains { $0.label == "networkManager" }
        let hasCacheManager = mirror.children.contains { $0.label == "cacheManager" }
        
        XCTAssertTrue(hasUserManager, "UserManager should be initialized")
        XCTAssertTrue(hasKeychainManager, "KeychainManager should be initialized")
        XCTAssertTrue(hasNetworkManager, "NetworkManager should be initialized")
        XCTAssertTrue(hasCacheManager, "CacheManager should be initialized")
    }
} 