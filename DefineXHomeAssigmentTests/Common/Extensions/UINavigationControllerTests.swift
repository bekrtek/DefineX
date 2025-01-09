import XCTest
@testable import DefineXHomeAssigment

final class UINavigationControllerTests: XCTestCase {
    
    var sut: UINavigationController!
    
    override func setUp() {
        super.setUp()
        sut = UINavigationController()
        sut.setupNavigationBarAppearance()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_setupNavigationBarAppearance_shouldConfigureCorrectly() {
        // Then
        XCTAssertEqual(sut.navigationBar.tintColor, .black)
        
        if #available(iOS 15.0, *) {
            let appearance = sut.navigationBar.standardAppearance
            XCTAssertEqual(appearance.backgroundColor, .white)
            XCTAssertEqual(appearance.shadowColor, .clear)
            
            let titleTextAttributes = appearance.titleTextAttributes
            XCTAssertEqual(titleTextAttributes[.foregroundColor] as? UIColor, .black)
            XCTAssertNotNil(titleTextAttributes[.font])
            
            XCTAssertEqual(sut.navigationBar.scrollEdgeAppearance, appearance)
            XCTAssertEqual(sut.navigationBar.compactAppearance, appearance)
        } else {
            XCTAssertEqual(sut.navigationBar.barTintColor, .white)
            XCTAssertNotNil(sut.navigationBar.shadowImage)
            
            let titleTextAttributes = sut.navigationBar.titleTextAttributes
            XCTAssertEqual(titleTextAttributes?[.foregroundColor] as? UIColor, .black)
            XCTAssertNotNil(titleTextAttributes?[.font])
            XCTAssertFalse(sut.navigationBar.isTranslucent)
        }
    }
} 