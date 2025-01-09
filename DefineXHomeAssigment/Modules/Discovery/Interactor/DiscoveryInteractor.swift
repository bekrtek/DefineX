//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import Foundation

final class DiscoveryInteractor {
    // MARK: - Properties
    weak var presenter: DiscoveryInteractorOutputProtocol?
    private let networkManager: NetworkManagerProtocol
    private let cacheManager: CacheManagerProtocol
    
    let dispatchGroup = DispatchGroup()

    var firstListError: Error? = nil
    var firstList: [DiscoveryItem]? = nil

    var secondListError: Error? = nil
    var secondList: [DiscoveryItem]? = nil

    var twoColumnListError: Error? = nil
    var twoColumnList: [DiscoveryItem]? = nil

    // MARK: - Initialization
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared,
         cacheManager: CacheManagerProtocol = CacheManager.shared) {
        self.networkManager = networkManager
        self.cacheManager = cacheManager
    }
}

// MARK: - DiscoveryInteractorProtocol
extension DiscoveryInteractor: DiscoveryInteractorProtocol {
    func fetchDiscoveryData() {
        // Reset previous data
        firstList = nil
        firstListError = nil
        secondList = nil
        secondListError = nil
        twoColumnList = nil
        twoColumnListError = nil
        
        let group = DispatchGroup()
        
        // Helper method to handle network requests
        func fetchList(
            endpoint: DiscoveryEndpoint,
            completion: @escaping (Result<[DiscoveryItem], NetworkError>) -> Void
        ) {
            group.enter()
            networkManager.request(
                endpoint: endpoint,
                responseType: DiscoveryResponse.self,
                useCache: true
            ) { result in
                completion(result.map { $0.list })
                group.leave()
            }
        }

        // Fetch First Horizontal List
        fetchList(endpoint: .firstHorizontalList) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.firstList = list
            case .failure(let error):
                self.firstListError = error
            }
        }

        // Fetch Second Horizontal List
        fetchList(endpoint: .secondHorizontalList) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.secondList = list
            case .failure(let error):
                self.secondListError = error
            }
        }

        // Fetch Two Column List
        fetchList(endpoint: .thirdTwoColumnList) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.twoColumnList = list
            case .failure(let error):
                self.twoColumnListError = error
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }

            if let error = self.firstListError ?? self.secondListError ?? self.twoColumnListError {
                self.presenter?.fetchFailure(error: error)
                return
            }

            guard
                let firstList = self.firstList,
                let secondList = self.secondList,
                let twoColumnList = self.twoColumnList
            else {
                self.presenter?.fetchFailure(error: NSError(domain: "DataError",
                                                          code: -1,
                                                          userInfo: [NSLocalizedDescriptionKey: "Unexpected nil data"]))
                return
            }

            self.presenter?.fetchSuccess(
                firstList: firstList,
                secondList: secondList,
                twoColumnList: twoColumnList
            )
        }
    }
}
