import XCTest
@testable import DefineXHomeAssigment

final class UserManagerTests: XCTestCase {
    var sut: UserManager!
    let testEmail = "test@example.com"
    let testToken = "test_token_12345"
    
    override func setUp() {
        super.setUp()
        sut = UserManager.shared
        // Clean up any existing test data
        sut.logout()
    }
    
    override func tearDown() {
        sut.logout()
        sut = nil
        super.tearDown()
    }
    
    func testSharedInstance() {
        // Given
        let instance1 = UserManager.shared
        let instance2 = UserManager.shared
        
        // Then
        XCTAssertTrue(instance1 === instance2, "Shared instances should be identical")
    }
    
    func testInitialState() {
        // Then
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertNil(sut.currentToken)
        XCTAssertNil(sut.userEmail)
    }
    
    func testLogin() {
        // When
        sut.login(with: testToken, email: testEmail)
        
        // Then
        XCTAssertTrue(sut.isLoggedIn)
        XCTAssertEqual(sut.currentToken, testToken)
        XCTAssertEqual(sut.userEmail, testEmail)
    }
    
    func testLogout() {
        // Given
        sut.login(with: testToken, email: testEmail)
        
        // When
        sut.logout()
        
        // Then
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertNil(sut.currentToken)
        XCTAssertNil(sut.userEmail)
    }
    
    func testValidateSessionWithValidSession() {
        // Given
        sut.login(with: testToken, email: testEmail)
        
        // When
        let isValid = sut.validateSession()
        
        // Then
        XCTAssertTrue(isValid)
        XCTAssertTrue(sut.isLoggedIn)
        XCTAssertNotNil(sut.currentToken)
    }
    
    func testValidateSessionWithInvalidSession() {
        // Given
        sut.isLoggedIn = true // Manually set isLoggedIn without token
        
        // When
        let isValid = sut.validateSession()
        
        // Then
        XCTAssertFalse(isValid)
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertNil(sut.currentToken)
    }
    
    func testLoginPersistence() {
        // Given
        sut.login(with: testToken, email: testEmail)
        
        // When
        let newInstance = UserManager.shared
        
        // Then
        XCTAssertTrue(newInstance.isLoggedIn)
        XCTAssertEqual(newInstance.currentToken, testToken)
        XCTAssertEqual(newInstance.userEmail, testEmail)
    }
    
    func testLogoutPersistence() {
        // Given
        sut.login(with: testToken, email: testEmail)
        sut.logout()
        
        // When
        let newInstance = UserManager.shared
        
        // Then
        XCTAssertFalse(newInstance.isLoggedIn)
        XCTAssertNil(newInstance.currentToken)
        XCTAssertNil(newInstance.userEmail)
    }
    
    func testMultipleLogins() {
        // Given
        let firstToken = "token1"
        let firstEmail = "first@example.com"
        let secondToken = "token2"
        let secondEmail = "second@example.com"
        
        // When
        sut.login(with: firstToken, email: firstEmail)
        sut.login(with: secondToken, email: secondEmail)
        
        // Then
        XCTAssertTrue(sut.isLoggedIn)
        XCTAssertEqual(sut.currentToken, secondToken)
        XCTAssertEqual(sut.userEmail, secondEmail)
    }
} 