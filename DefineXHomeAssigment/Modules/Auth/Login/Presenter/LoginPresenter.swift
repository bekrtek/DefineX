//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import Foundation

final class LoginPresenter {
    // MARK: - Properties
    weak var view: LoginViewProtocol?
    var interactor: LoginInteractorProtocol?
    var router: LoginRouterProtocol?
    
    // MARK: - Private Methods
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - LoginPresenterProtocol
extension LoginPresenter: LoginPresenterProtocol {
    func viewDidLoad() {
        AnalyticsManager.shared.logEvent(.viewScreen(name: "login"))
        
        // Check for existing session first
        interactor?.checkExistingSession()
    }
    
    func loginButtonTapped(email: String, password: String) {
        guard validateEmail(email) else {
            view?.showError("login.error.invalid_email".localized)
            AnalyticsManager.shared.logEvent(.error(description: "Invalid email format"))
            CrashReporter.shared.log(message: "Login attempt with invalid email format")
            return
        }
        
        guard password.count >= 6 else {
            view?.showError("login.error.password_short".localized)
            AnalyticsManager.shared.logEvent(.error(description: "Password too short"))
            CrashReporter.shared.log(message: "Login attempt with short password")
            return
        }
        
        view?.showLoading()
        AnalyticsManager.shared.logEvent(.buttonTap(name: "login_button"))
        CrashReporter.shared.log(message: "Login attempt started")
        interactor?.login(email: email, password: password)
    }
}

// MARK: - LoginInteractorOutputProtocol
extension LoginPresenter: LoginInteractorOutputProtocol {
    func loginSuccess(token: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.hideLoading()
            AnalyticsManager.shared.logEvent(.login(success: true))
            CrashReporter.shared.setUserIdentifier(token)
            CrashReporter.shared.log(message: "Login successful")
            self?.router?.navigateToMainScreen()
        }
    }
    
    func loginFailure(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.hideLoading()
            self?.view?.showError(error.localizedDescription)
            AnalyticsManager.shared.logEvent(.login(success: false))
            CrashReporter.shared.log(error: error)
            CrashReporter.shared.log(message: "Login failed")
        }
    }
    
    func autoLoginSuccess(token: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.hideLoading()
            AnalyticsManager.shared.logEvent(.login(success: true))
            CrashReporter.shared.setUserIdentifier(token)
            CrashReporter.shared.log(message: "Auto login successful")
        }
    }
}
