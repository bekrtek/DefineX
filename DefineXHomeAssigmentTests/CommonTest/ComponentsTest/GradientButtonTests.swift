import XCTest
@testable import DefineXHomeAssigment

@MainActor
final class GradientButtonTests: XCTestCase {
    var sut: GradientButton!
    
    override func setUp() {
        super.setUp()
        sut = GradientButton(frame: .zero)
        sut.setTitle("Test Button", for: .normal)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    func testInitialization() {
        // Then
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertEqual(sut.title(for: .normal), "Test Button")
        XCTAssertNotNil(sut.gradientLayer)
    }
    
    func testCustomInitialization() {
        // Given
        let customTitle = "Custom Button"
        
        // When
        let button = GradientButton(frame: .zero)
        button.setTitle(customTitle, for: .normal)
        
        // Then
        XCTAssertEqual(button.title(for: .normal), customTitle)
        XCTAssertNotNil(button.gradientLayer)
    }
    
    // MARK: - Layout Tests
    func testButtonLayout() {
        // When
        sut.layoutSubviews()
        
        // Then
        XCTAssertEqual(sut.layer.cornerRadius, 8)
        XCTAssertTrue(sut.clipsToBounds)
    }
    
    func testGradientLayout() {
        // Then
        XCTAssertEqual(sut.gradientLayer.startPoint, CGPoint(x: 0, y: 0))
        XCTAssertEqual(sut.gradientLayer.endPoint, CGPoint(x: 1, y: 0))
        XCTAssertEqual(sut.gradientLayer.colors?.count, 2)
    }
    
    // MARK: - State Tests
    func testEnabledState() {
        // When
        sut.isEnabled = true
        
        // Then
        XCTAssertTrue(sut.isEnabled)
    }
    
    func testDisabledState() {
        // When
        sut.isEnabled = false
        
        // Then
        XCTAssertFalse(sut.isEnabled)
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
    
    // MARK: - Title Tests
    func testSetTitle() {
        // Given
        let newTitle = "New Title"
        
        // When
        sut.setTitle(newTitle, for: .normal)
        
        // Then
        XCTAssertEqual(sut.title(for: .normal), newTitle)
    }
} 