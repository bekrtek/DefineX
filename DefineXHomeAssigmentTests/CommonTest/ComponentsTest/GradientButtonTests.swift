import XCTest
@testable import DefineXHomeAssigment

@MainActor
final class GradientButtonTests: XCTestCase {
    var sut: GradientButton!
    
    override func setUp() {
        super.setUp()
        sut = GradientButton(title: "Test Button")
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
        XCTAssertNotNil(sut.gradientLayer)
    }
    
    func testCustomInitialization() {
        // Given
        let customTitle = "Custom Button"
        
        // When
        let button = GradientButton(title: customTitle)
        
        // Then
        XCTAssertEqual(button.titleLabel?.text, customTitle)
        XCTAssertNotNil(button.gradientLayer)
    }
    
    // MARK: - Layout Tests
    func testButtonLayout() {
        // Then
        XCTAssertEqual(sut.layer.cornerRadius, 8)
        XCTAssertEqual(sut.contentEdgeInsets, UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
    }
    
    func testGradientLayout() {
        // Then
        XCTAssertEqual(sut.gradientLayer.startPoint, CGPoint(x: 0, y: 0))
        XCTAssertEqual(sut.gradientLayer.endPoint, CGPoint(x: 1, y: 1))
        XCTAssertEqual(sut.gradientLayer.locations, [0, 1])
        XCTAssertEqual(sut.gradientLayer.cornerRadius, 8)
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
    
    // MARK: - Gradient Tests
    func testGradientColors() {
        // Then
        let colors = sut.gradientLayer.colors as? [CGColor]
        XCTAssertNotNil(colors)
        XCTAssertEqual(colors?.count, 2)
    }
    
    func testLayoutSubviews() {
        // When
        sut.layoutSubviews()
        
        // Then
        XCTAssertEqual(sut.gradientLayer.frame, sut.bounds)
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
    
    // MARK: - Title Tests
    func testSetTitle() {
        // Given
        let newTitle = "New Title"
        
        // When
        sut.setTitle(newTitle, for: .normal)
        
        // Then
        XCTAssertEqual(sut.titleLabel?.text, newTitle)
    }
    
    func testTitleColor() {
        // Then
        XCTAssertEqual(sut.titleLabel?.textColor, .white)
    }
} 