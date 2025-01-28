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
    
    func testSharedInstance() {
        // Given
        let instance1 = ApplicationManager.shared
        let instance2 = ApplicationManager.shared
        
        // Then
        XCTAssertTrue(instance1 === instance2, "Shared instances should be identical")
    }
} 
