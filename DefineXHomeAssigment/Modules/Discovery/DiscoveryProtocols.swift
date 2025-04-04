//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import Foundation
import UIKit

// MARK: - View
protocol DiscoveryViewProtocol: AnyObject {
    var presenter: DiscoveryPresenterProtocol? { get set }
    
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func updateFirstHorizontalList(_ items: [ProductModel])
    func updateSecondHorizontalList(_ items: [ProductModel])
    func updateTwoColumnList(_ items: [ProductModel])
}

// MARK: - Presenter
protocol DiscoveryPresenterProtocol: AnyObject {
    var view: DiscoveryViewProtocol? { get set }
    var interactor: DiscoveryInteractorProtocol? { get set }
    var router: DiscoveryRouterProtocol? { get set }
    
    func viewDidLoad()
    func refreshData()
    func didSelectItem(_ item: ProductModel)
}

// MARK: - Interactor
protocol DiscoveryInteractorProtocol: AnyObject {
    var presenter: DiscoveryInteractorOutputProtocol? { get set }
    
    func fetchDiscoveryData()
}

// MARK: - Interactor Output
protocol DiscoveryInteractorOutputProtocol: AnyObject {
    func fetchSuccess(firstList: [ProductModel], secondList: [ProductModel], twoColumnList: [ProductModel])
    func fetchFailure(error: Error)
}

// MARK: - Router
protocol DiscoveryRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    static func createModule() -> UIViewController
    func showComingSoonAlert()
}
