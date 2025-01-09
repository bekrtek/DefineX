//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import Foundation

final class DiscoveryPresenter {
    // MARK: - Properties
    weak var view: DiscoveryViewProtocol?
    var interactor: DiscoveryInteractorProtocol?
    var router: DiscoveryRouterProtocol?
}

// MARK: - DiscoveryPresenterProtocol
extension DiscoveryPresenter: DiscoveryPresenterProtocol {
    func viewDidLoad() {
        AnalyticsManager.shared.logEvent(.viewScreen(name: "discovery"))
        CrashReporter.shared.log(message: "Discovery screen viewed")
        view?.showLoading()
        interactor?.fetchDiscoveryData()
    }
    
    func refreshData() {
        AnalyticsManager.shared.logEvent(.buttonTap(name: "refresh_discovery"))
        CrashReporter.shared.log(message: "Discovery refresh started")
        interactor?.fetchDiscoveryData()
    }
    
    func didSelectItem(_ item: DiscoveryItem) {
        AnalyticsManager.shared.logEvent(.buttonTap(name: "discovery item selected"))
        CrashReporter.shared.log(message: "Selected discovery item")
        router?.showComingSoonAlert()
    }
}

// MARK: - DiscoveryInteractorOutputProtocol
extension DiscoveryPresenter: DiscoveryInteractorOutputProtocol {
    func fetchSuccess(firstList: [DiscoveryItem], secondList: [DiscoveryItem], twoColumnList: [DiscoveryItem]) {
        view?.hideLoading()
        view?.updateFirstHorizontalList(firstList)
        view?.updateSecondHorizontalList(secondList)
        view?.updateTwoColumnList(twoColumnList)
        
        CrashReporter.shared.log(message: "Discovery data fetched successfully")
        CrashReporter.shared.setCustomKeysAndValues([
            "first_list_count": firstList.count,
            "second_list_count": secondList.count,
            "two_column_list_count": twoColumnList.count
        ])
    }
    
    func fetchFailure(error: Error) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
        AnalyticsManager.shared.logEvent(.error(description: "Discovery fetch error: \(error.localizedDescription)"))
        CrashReporter.shared.log(error: error)
        CrashReporter.shared.log(message: "Discovery data fetch failed")
    }
} 
