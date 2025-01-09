//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import Foundation
import UIKit

// MARK: - View
protocol LoginViewProtocol: AnyObject {
    var presenter: LoginPresenterProtocol? { get set }
    
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
}

// MARK: - Presenter
protocol LoginPresenterProtocol: AnyObject {
    var view: LoginViewProtocol? { get set }
    var interactor: LoginInteractorProtocol? { get set }
    var router: LoginRouterProtocol? { get set }
    
    func viewDidLoad()
    func loginButtonTapped(email: String, password: String)
}

// MARK: - Interactor
protocol LoginInteractorProtocol: AnyObject {
    var presenter: LoginInteractorOutputProtocol? { get set }
    
    func login(email: String, password: String)
    func checkExistingSession()
}

// MARK: - Interactor Output
protocol LoginInteractorOutputProtocol: AnyObject {
    func loginSuccess(token: String)
    func loginFailure(error: Error)
    func autoLoginSuccess(token: String)
}

// MARK: - Router
protocol LoginRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    static func createModule() -> UIViewController
    func navigateToMainScreen()
}
