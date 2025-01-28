import XCTest
@testable import DefineXHomeAssigment

final class LoginInteractorTests: XCTestCase {
    var sut: LoginInteractor!
    var mockNetworkManager: MockNetworkManager!
    var mockUserManager: MockUserManager!
    var mockPresenter: MockLoginInteractorOutput!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockUserManager = MockUserManager()
        mockPresenter = MockLoginInteractorOutput()
        sut = LoginInteractor(networkManager: mockNetworkManager, userManager: mockUserManager)
        sut.presenter = mockPresenter
    }
    
    override func tearDown() {
        mockNetworkManager = nil
        mockUserManager = nil
        mockPresenter = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Mock Classes
    class MockNetworkManager: NetworkManagerProtocol {
        var shouldSucceed = true
        var lastEndpoint: Endpoint?
        var mockToken = "mock_token"
        
        func request<T>(endpoint: Endpoint, responseType: T.Type, useCache: Bool, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
            lastEndpoint = endpoint
            
            if shouldSucceed {
                if let loginResponse = LoginResponse(token: mockToken) as? T {
                    completion(.success(loginResponse))
                }
            } else {
                completion(.failure(.unauthorized))
            }
        }
    }
    
    class MockUserManager: UserManager {
        var isLoginCalled = false
        var isLogoutCalled = false
        var isValidateSessionCalled = false
        var shouldValidateSession = true
        
        override func login(with token: String, email: String) {
            isLoginCalled = true
            super.login(with: token, email: email)
        }
        
        override func logout() {
            isLogoutCalled = true
            super.logout()
        }
        
        override func validateSession() -> Bool {
            isValidateSessionCalled = true
            return shouldValidateSession
        }
    }
    
    class MockLoginInteractorOutput: LoginInteractorOutputProtocol {
        var loginSuccessCalled = false
        var loginFailureCalled = false
        var autoLoginSuccessCalled = false
        var lastToken: String?
        var lastError: Error?
        
        func loginSuccess(token: String) {
            loginSuccessCalled = true
            lastToken = token
        }
        
        func loginFailure(error: Error) {
            loginFailureCalled = true
            lastError = error
        }
        
        func autoLoginSuccess(token: String) {
            autoLoginSuccessCalled = true
            lastToken = token
        }
    }
    
    // MARK: - Tests
    func testLoginSuccess() {
        // Given
        let email = "test@example.com"
        let password = "password123"
        mockNetworkManager.shouldSucceed = true
        
        // When
        sut.login(email: email, password: password)
        
        // Then
        XCTAssertTrue(mockPresenter.loginSuccessCalled)
        XCTAssertEqual(mockPresenter.lastToken, mockNetworkManager.mockToken)
        XCTAssertTrue(mockUserManager.isLoginCalled)
        XCTAssertNotNil(mockNetworkManager.lastEndpoint)
    }
    
    func testLoginFailure() {
        // Given
        let email = "test@example.com"
        let password = "password123"
        mockNetworkManager.shouldSucceed = false
        
        // When
        sut.login(email: email, password: password)
        
        // Then
        XCTAssertTrue(mockPresenter.loginFailureCalled)
        XCTAssertNotNil(mockPresenter.lastError)
        XCTAssertFalse(mockUserManager.isLoginCalled)
    }
    
    func testCheckExistingSessionWithValidSession() {
        // Given
        mockUserManager.shouldValidateSession = true
        mockUserManager.login(with: "existing_token", email: "test@example.com")
        
        // When
        sut.checkExistingSession()
        
        // Then
        XCTAssertTrue(mockUserManager.isValidateSessionCalled)
        XCTAssertTrue(mockPresenter.autoLoginSuccessCalled)
        XCTAssertEqual(mockPresenter.lastToken, "existing_token")
    }
    
    func testCheckExistingSessionWithInvalidSession() {
        // Given
        mockUserManager.shouldValidateSession = false
        
        // When
        sut.checkExistingSession()
        
        // Then
        XCTAssertTrue(mockUserManager.isValidateSessionCalled)
        XCTAssertFalse(mockPresenter.autoLoginSuccessCalled)
    }
    
    func testCheckExistingSessionWithNoToken() {
        // Given
        mockUserManager.shouldValidateSession = true
        mockUserManager.logout() // Clear any existing token
        
        // When
        sut.checkExistingSession()
        
        // Then
        XCTAssertTrue(mockUserManager.isValidateSessionCalled)
        XCTAssertTrue(mockPresenter.loginFailureCalled)
        XCTAssertTrue(mockPresenter.lastError is NetworkError)
        XCTAssertEqual(mockPresenter.lastError as? NetworkError, .unauthorized)
    }
} 