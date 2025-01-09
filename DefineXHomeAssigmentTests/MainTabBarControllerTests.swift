import XCTest
@testable import DefineXHomeAssigment

final class MainTabBarControllerTests: XCTestCase {
    
    var sut: MainTabBarController!
    
    override func setUp() {
        super.setUp()
        sut = MainTabBarController()
        _ = sut.view // Force view to load
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_shouldSetupFiveTabs() {
        // Then
        XCTAssertEqual(sut.viewControllers?.count, 5)
        XCTAssertTrue(sut.viewControllers?[0] is UINavigationController)
        XCTAssertTrue((sut.viewControllers?[0] as? UINavigationController)?.viewControllers.first is DiscoveryViewController)
    }
    
    func test_viewDidLoad_shouldSetupCorrectTabBarItems() {
        // Then
        XCTAssertEqual(sut.tabBar.items?.count, 5)
        
        // Discovery Tab
        XCTAssertEqual(sut.tabBar.items?[0].title, "discovery.title".localized)
        XCTAssertNotNil(sut.tabBar.items?[0].image)
        XCTAssertNotNil(sut.tabBar.items?[0].selectedImage)
        XCTAssertEqual(sut.tabBar.items?[0].tag, 0)
        
        // Categories Tab
        XCTAssertEqual(sut.tabBar.items?[1].title, "categories.title".localized)
        XCTAssertNotNil(sut.tabBar.items?[1].image)
        XCTAssertNotNil(sut.tabBar.items?[1].selectedImage)
        XCTAssertEqual(sut.tabBar.items?[1].tag, 1)
        
        // Cart Tab
        XCTAssertEqual(sut.tabBar.items?[2].title, "cart.title".localized)
        XCTAssertNotNil(sut.tabBar.items?[2].image)
        XCTAssertNotNil(sut.tabBar.items?[2].selectedImage)
        XCTAssertEqual(sut.tabBar.items?[2].tag, 2)
        
        // Favorites Tab
        XCTAssertEqual(sut.tabBar.items?[3].title, "favorites.title".localized)
        XCTAssertNotNil(sut.tabBar.items?[3].image)
        XCTAssertNotNil(sut.tabBar.items?[3].selectedImage)
        XCTAssertEqual(sut.tabBar.items?[3].tag, 3)
        
        // Profile Tab
        XCTAssertEqual(sut.tabBar.items?[4].title, "profile.title".localized)
        XCTAssertNotNil(sut.tabBar.items?[4].image)
        XCTAssertNotNil(sut.tabBar.items?[4].selectedImage)
        XCTAssertEqual(sut.tabBar.items?[4].tag, 4)
    }
    
    func test_tabBarDelegate_shouldAllowSelection() {
        // Given
        let fromIndex = 0
        let toIndex = 1
        
        // When
        guard let toVC = sut.viewControllers?[toIndex] else {
            XCTFail("Failed to get view controller")
            return
        }
        
        let shouldSelect = sut.tabBarController(sut, shouldSelect: toVC)
        
        // Then
        XCTAssertTrue(shouldSelect)
    }
    
    func test_tabBarAppearance_shouldHaveCorrectConfiguration() {
        // Then
        XCTAssertEqual(sut.tabBar.itemPositioning, .centered)
        XCTAssertEqual(sut.tabBar.itemSpacing, 16)
        XCTAssertEqual(sut.tabBar.tintColor, .systemBlue)
        
        if #available(iOS 15.0, *) {
            XCTAssertNotNil(sut.tabBar.standardAppearance)
            XCTAssertNotNil(sut.tabBar.scrollEdgeAppearance)
        }
    }
    
    func test_tabBarItemAttributes_shouldHaveCorrectTextAttributes() {
        // Given
        let item = sut.tabBar.items?.first
        
        // Then
        let normalAttributes = item?.titleTextAttributes(for: .normal)
        let selectedAttributes = item?.titleTextAttributes(for: .selected)
        
        XCTAssertEqual(normalAttributes?[.foregroundColor] as? UIColor, .clear)
        XCTAssertEqual(selectedAttributes?[.foregroundColor] as? UIColor, .systemBlue)
        XCTAssertNotNil(selectedAttributes?[.font])
    }
} 