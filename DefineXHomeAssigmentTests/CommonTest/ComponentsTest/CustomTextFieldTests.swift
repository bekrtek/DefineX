import XCTest
@testable import DefineXHomeAssigment

@MainActor
final class CustomTextFieldTests: XCTestCase {
    var sut: CustomTextField!
    
    override func setUp() {
        super.setUp()
        sut = CustomTextField(title: "Test Title")
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    func testInitialization() {
        // Then
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.getText(), "")
    }
    
    // MARK: - Configuration Tests
    func testSetPlaceholder() {
        // When
        sut.setPlaceholder("Test Placeholder")
        
        // Then
        XCTAssertNotNil(sut)
    }
    
    func testSetKeyboardType() {
        // When
        sut.setKeyboardType(.emailAddress)
        
        // Then
        XCTAssertNotNil(sut)
    }
    
    func testSetSecureTextEntry() {
        // When
        sut.setSecureTextEntry(true)
        
        // Then
        XCTAssertTrue(sut.isSecureTextEntry)
        
        // When
        sut.setSecureTextEntry(false)
        
        // Then
        XCTAssertFalse(sut.isSecureTextEntry)
    }
    
    func testSetImage() {
        // Given
        let image = UIImage()
        
        // When
        sut.setImage(image)
        
        // Then
        XCTAssertNotNil(sut)
    }
    
    // MARK: - Text Handling Tests
    func testTextInput() {
        // Given
        let testText = "Test Input"
        
        // When
        sut.setText(testText)
        
        // Then
        XCTAssertEqual(sut.getText(), testText)
    }
    
    func testClearText() {
        // Given
        sut.setText("Some text")
        
        // When
        sut.setText("")
        
        // Then
        XCTAssertEqual(sut.getText(), "")
    }
} 
