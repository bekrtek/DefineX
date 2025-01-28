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
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertEqual(sut.titleLabel.text, "Test Title")
        XCTAssertNotNil(sut.textField)
        XCTAssertNotNil(sut.stackView)
    }
    
    // MARK: - State Tests
    func testDefaultState() {
        // When
        sut.setState(.default)
        
        // Then
        XCTAssertEqual(sut.textField.layer.borderColor, Colors.Border.default.cgColor)
        XCTAssertTrue(sut.textField.isEnabled)
    }
    
    func testErrorState() {
        // When
        sut.setState(.error)
        
        // Then
        XCTAssertEqual(sut.textField.layer.borderColor, Colors.Border.error.cgColor)
        XCTAssertTrue(sut.textField.isEnabled)
    }
    
    func testDisabledState() {
        // When
        sut.setState(.disabled)
        
        // Then
        XCTAssertEqual(sut.textField.layer.borderColor, Colors.Border.disabled.cgColor)
        XCTAssertFalse(sut.textField.isEnabled)
    }
    
    // MARK: - Configuration Tests
    func testSetPlaceholder() {
        // When
        sut.setPlaceholder("Test Placeholder")
        
        // Then
        XCTAssertEqual(sut.textField.placeholder, "Test Placeholder")
    }
    
    func testSetKeyboardType() {
        // When
        sut.setKeyboardType(.emailAddress)
        
        // Then
        XCTAssertEqual(sut.textField.keyboardType, .emailAddress)
    }
    
    func testSetSecureTextEntry() {
        // When
        sut.setSecureTextEntry(true)
        
        // Then
        XCTAssertTrue(sut.textField.isSecureTextEntry)
        
        // When
        sut.setSecureTextEntry(false)
        
        // Then
        XCTAssertFalse(sut.textField.isSecureTextEntry)
    }
    
    func testSetImage() {
        // Given
        let image = UIImage()
        
        // When
        sut.setImage(image)
        
        // Then
        XCTAssertNotNil(sut.textField.leftView)
        XCTAssertEqual(sut.textField.leftViewMode, .always)
    }
    
    // MARK: - Text Handling Tests
    func testTextInput() {
        // Given
        let testText = "Test Input"
        
        // When
        sut.textField.text = testText
        
        // Then
        XCTAssertEqual(sut.textField.text, testText)
    }
    
    func testClearText() {
        // Given
        sut.textField.text = "Some text"
        
        // When
        sut.textField.text = ""
        
        // Then
        XCTAssertEqual(sut.textField.text, "")
    }
    
    // MARK: - Layout Tests
    func testStackViewArrangement() {
        // Then
        XCTAssertEqual(sut.stackView.axis, .vertical)
        XCTAssertEqual(sut.stackView.spacing, 8)
        XCTAssertEqual(sut.stackView.arrangedSubviews.count, 2)
        XCTAssertTrue(sut.stackView.arrangedSubviews.contains(sut.titleLabel))
        XCTAssertTrue(sut.stackView.arrangedSubviews.contains(sut.textField))
    }
    
    func testTextFieldLayout() {
        // Then
        XCTAssertEqual(sut.textField.layer.cornerRadius, 8)
        XCTAssertEqual(sut.textField.layer.borderWidth, 1)
        XCTAssertNotNil(sut.textField.layer.borderColor)
    }
} 