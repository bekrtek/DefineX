//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import UIKit

final class LoginRouter {
    // MARK: - Properties
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    static func createModule() -> UIViewController {
        let router = LoginRouter()
        let view = LoginViewController()
        let presenter = LoginPresenter()
        let interactor = LoginInteractor()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        
        router.viewController = view
        
        return view
    }
}

// MARK: - LoginRouterProtocol
extension LoginRouter: LoginRouterProtocol {
    func navigateToMainScreen() {
        DispatchQueue.main.async {
            let tabBarController = MainTabBarController()
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = tabBarController
                window.makeKeyAndVisible()
            }
        }
    }
} 
