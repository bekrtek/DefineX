//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import UIKit

final class DiscoveryRouter {
    // MARK: - Properties
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    static func createModule() -> UIViewController {
        let router = DiscoveryRouter()
        let view = DiscoveryViewController()
        let presenter = DiscoveryPresenter()
        let interactor = DiscoveryInteractor()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        
        router.viewController = view
        
        return view
    }
}

// MARK: - DiscoveryRouterProtocol
extension DiscoveryRouter: DiscoveryRouterProtocol {
    func showComingSoonAlert() {
        let alert = UIAlertController(
            title: "discovery.coming_soon.title".localized,
            message: "discovery.coming_soon.message".localized,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "common.ok".localized, style: .default))
        viewController?.present(alert, animated: true)
    }
} 
