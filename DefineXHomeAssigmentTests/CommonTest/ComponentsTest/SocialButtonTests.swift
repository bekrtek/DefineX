import XCTest
@testable import DefineXHomeAssigment

@MainActor
final class SocialButtonTests: XCTestCase {
    var sut: SocialButton!
    
    override func setUp() {
        super.setUp()
        sut = SocialButton(title: "Test Button", image: UIImage())
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    func testInitialization() {
        // Then
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertEqual(sut.titleLabel?.text, "Test Button")
        XCTAssertNotNil(sut.imageView)
    }
    
    func testCustomInitialization() {
        // Given
        let customTitle = "Custom Button"
        let customImage = UIImage()
        
        // When
        let button = SocialButton(title: customTitle, image: customImage)
        
        // Then
        XCTAssertEqual(button.titleLabel?.text, customTitle)
        XCTAssertNotNil(button.imageView)
    }
    
    // MARK: - Layout Tests
    func testButtonLayout() {
        // Then
        XCTAssertEqual(sut.layer.cornerRadius, 8)
        XCTAssertEqual(sut.contentEdgeInsets, UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
    }
    
    func testImageLayout() {
        // Then
        XCTAssertEqual(sut.imageEdgeInsets, UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8))
    }
    
    // MARK: - State Tests
    func testEnabledState() {
        // When
        sut.isEnabled = true
        
        // Then
        XCTAssertTrue(sut.isEnabled)
        XCTAssertEqual(sut.alpha, 1.0)
    }
    
    func testDisabledState() {
        // When
        sut.isEnabled = false
        
        // Then
        XCTAssertFalse(sut.isEnabled)
        XCTAssertEqual(sut.alpha, 0.5)
    }
    
    // MARK: - Configuration Tests
    func testSetBackgroundColor() {
        // Given
        let color = UIColor.red
        
        // When
        sut.setBackgroundColor(color)
        
        // Then
        XCTAssertEqual(sut.backgroundColor, color)
    }
    
    func testSetTitle() {
        // Given
        let newTitle = "New Title"
        
        // When
        sut.setTitle(newTitle, for: .normal)
        
        // Then
        XCTAssertEqual(sut.titleLabel?.text, newTitle)
    }
    
    // MARK: - Touch Handling Tests
    func testTouchDownState() {
        // When
        sut.touchesBegan([UITouch()], with: nil)
        
        // Then
        XCTAssertEqual(sut.alpha, 0.8)
    }
    
    func testTouchUpState() {
        // Given
        sut.touchesBegan([UITouch()], with: nil)
        
        // When
        sut.touchesEnded([UITouch()], with: nil)
        
        // Then
        XCTAssertEqual(sut.alpha, 1.0)
    }
    
    func testTouchCancelState() {
        // Given
        sut.touchesBegan([UITouch()], with: nil)
        
        // When
        sut.touchesCancelled([UITouch()], with: nil)
        
        // Then
        XCTAssertEqual(sut.alpha, 1.0)
    }
} 