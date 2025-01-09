import Foundation

final class LoginInteractor {
    // MARK: - Properties
    weak var presenter: LoginInteractorOutputProtocol?
    private let networkManager: NetworkManagerProtocol
    private let userManager: UserManager
    
    // MARK: - Initialization
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared,
         userManager: UserManager = UserManager.shared) {
        self.networkManager = networkManager
        self.userManager = userManager
    }
}

// MARK: - LoginInteractorProtocol
extension LoginInteractor: LoginInteractorProtocol {
    func login(email: String, password: String) {
        networkManager.request(
            endpoint: LoginEndpoint.login(email: email, password: password),
            responseType: LoginResponse.self,
            useCache: false
        ) { [weak self] result in
            switch result {
            case .success(let response):
                if let loginResponse = response as LoginResponse? {
                    self?.userManager.login(with: loginResponse.token, email: email)
                    self?.presenter?.loginSuccess(token: loginResponse.token)
                }
            case .failure(let error):
                self?.presenter?.loginFailure(error: error)
            }
        }
    }
    
    func checkExistingSession() {
        // First validate local session
        guard userManager.validateSession() else {
            return
        }
        
        // Get token from secure storage
        guard let token = userManager.currentToken else {
            presenter?.loginFailure(error: NetworkError.unauthorized)
            return
        }
        
        // Validate token with server (optional, depends on your requirements)
        // For now, just proceed with the stored token
        presenter?.autoLoginSuccess(token: token)
    }
} 
