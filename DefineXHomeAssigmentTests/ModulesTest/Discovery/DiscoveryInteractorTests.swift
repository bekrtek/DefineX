import XCTest
@testable import DefineXHomeAssigment

final class DiscoveryInteractorTests: XCTestCase {
    var sut: DiscoveryInteractor!
    var mockNetworkManager: MockNetworkManager!
    var mockCacheManager: MockCacheManager!
    var mockPresenter: MockDiscoveryInteractorOutput!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockCacheManager = MockCacheManager()
        mockPresenter = MockDiscoveryInteractorOutput()
        sut = DiscoveryInteractor(networkManager: mockNetworkManager, cacheManager: mockCacheManager)
        sut.presenter = mockPresenter
    }
    
    override func tearDown() {
        mockNetworkManager = nil
        mockCacheManager = nil
        mockPresenter = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Mock Classes
    class MockNetworkManager: NetworkManagerProtocol {
        var responses: [String: Result<DiscoveryResponse, NetworkError>] = [:]
        var requestCallCount = 0
        var lastEndpoint: Endpoint?
        
        func request<T>(endpoint: Endpoint, responseType: T.Type, useCache: Bool, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
            requestCallCount += 1
            lastEndpoint = endpoint
            
            if let response = responses[endpoint.path] {
                switch response {
                case .success(let discoveryResponse):
                    if let result = discoveryResponse as? T {
                        completion(.success(result))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        func setupMockResponses(firstList: Result<DiscoveryResponse, NetworkError>,
                              secondList: Result<DiscoveryResponse, NetworkError>,
                              twoColumnList: Result<DiscoveryResponse, NetworkError>) {
            responses[DiscoveryEndpoint.firstHorizontalList.path] = firstList
            responses[DiscoveryEndpoint.secondHorizontalList.path] = secondList
            responses[DiscoveryEndpoint.thirdTwoColumnList.path] = twoColumnList
        }
    }
    
    class MockCacheManager: CacheManagerProtocol {
        var savedData: [String: Any] = [:]
        var loadCallCount = 0
        var saveCallCount = 0
        
        func save<T>(_ data: T, forKey key: String) throws where T : Encodable {
            savedData[key] = data
            saveCallCount += 1
        }
        
        func load<T>(forKey key: String) throws -> T where T : Decodable {
            loadCallCount += 1
            guard let data = savedData[key] as? T else {
                throw CacheError.notFound
            }
            return data
        }
    }
    
    class MockDiscoveryInteractorOutput: DiscoveryInteractorOutputProtocol {
        var fetchSuccessCalled = false
        var fetchFailureCalled = false
        var lastFirstList: [ProductModel]?
        var lastSecondList: [ProductModel]?
        var lastTwoColumnList: [ProductModel]?
        var lastError: Error?
        
        func fetchSuccess(firstList: [ProductModel], secondList: [ProductModel], twoColumnList: [ProductModel]) {
            fetchSuccessCalled = true
            self.lastFirstList = firstList
            self.lastSecondList = secondList
            self.lastTwoColumnList = twoColumnList
        }
        
        func fetchFailure(error: Error) {
            fetchFailureCalled = true
            lastError = error
        }
    }
    
    // MARK: - Helper Methods
    private func createMockProducts(count: Int, prefix: String) -> [ProductModel] {
        return (0..<count).map { index in
            ProductModel(
                id: index,
                description: "\(prefix)_product_\(index)",
                price: Price(value: Double(index * 10), currency: "$"),
                ratePercentage: index * 20
            )
        }
    }
    
    // MARK: - Tests
    func testFetchDiscoveryDataSuccess() {
        // Given
        let firstList = createMockProducts(count: 3, prefix: "first")
        let secondList = createMockProducts(count: 4, prefix: "second")
        let twoColumnList = createMockProducts(count: 6, prefix: "column")
        
        mockNetworkManager.setupMockResponses(
            firstList: .success(DiscoveryResponse(list: firstList)),
            secondList: .success(DiscoveryResponse(list: secondList)),
            twoColumnList: .success(DiscoveryResponse(list: twoColumnList))
        )
        
        // When
        sut.fetchDiscoveryData()
        
        // Then
        XCTAssertEqual(mockNetworkManager.requestCallCount, 3)
        XCTAssertTrue(mockPresenter.fetchSuccessCalled)
        XCTAssertEqual(mockPresenter.lastFirstList?.count, firstList.count)
        XCTAssertEqual(mockPresenter.lastSecondList?.count, secondList.count)
        XCTAssertEqual(mockPresenter.lastTwoColumnList?.count, twoColumnList.count)
    }
    
    func testFetchDiscoveryDataPartialFailure() {
        // Given
        let firstList = createMockProducts(count: 3, prefix: "first")
        mockNetworkManager.setupMockResponses(
            firstList: .success(DiscoveryResponse(list: firstList)),
            secondList: .failure(.serverError("Error")),
            twoColumnList: .success(DiscoveryResponse(list: []))
        )
        
        // When
        sut.fetchDiscoveryData()
        
        // Then
        XCTAssertEqual(mockNetworkManager.requestCallCount, 3)
        XCTAssertTrue(mockPresenter.fetchFailureCalled)
        XCTAssertNotNil(mockPresenter.lastError)
    }
    
    func testFetchDiscoveryDataAllFailure() {
        // Given
        mockNetworkManager.setupMockResponses(
            firstList: .failure(.serverError("Error 1")),
            secondList: .failure(.serverError("Error 2")),
            twoColumnList: .failure(.serverError("Error 3"))
        )
        
        // When
        sut.fetchDiscoveryData()
        
        // Then
        XCTAssertEqual(mockNetworkManager.requestCallCount, 3)
        XCTAssertTrue(mockPresenter.fetchFailureCalled)
        XCTAssertNotNil(mockPresenter.lastError)
    }
    
    func testFetchDiscoveryDataEmptyLists() {
        // Given
        mockNetworkManager.setupMockResponses(
            firstList: .success(DiscoveryResponse(list: [])),
            secondList: .success(DiscoveryResponse(list: [])),
            twoColumnList: .success(DiscoveryResponse(list: []))
        )
        
        // When
        sut.fetchDiscoveryData()
        
        // Then
        XCTAssertEqual(mockNetworkManager.requestCallCount, 3)
        XCTAssertTrue(mockPresenter.fetchSuccessCalled)
        XCTAssertEqual(mockPresenter.lastFirstList?.count, 0)
        XCTAssertEqual(mockPresenter.lastSecondList?.count, 0)
        XCTAssertEqual(mockPresenter.lastTwoColumnList?.count, 0)
    }
    
    func testFetchDiscoveryDataWithCache() {
        // Given
        let firstList = createMockProducts(count: 3, prefix: "first")
        let secondList = createMockProducts(count: 4, prefix: "second")
        let twoColumnList = createMockProducts(count: 6, prefix: "column")
        
        mockNetworkManager.setupMockResponses(
            firstList: .success(DiscoveryResponse(list: firstList)),
            secondList: .success(DiscoveryResponse(list: secondList)),
            twoColumnList: .success(DiscoveryResponse(list: twoColumnList))
        )
        
        // When
        sut.fetchDiscoveryData()
        
        // Then
        XCTAssertEqual(mockNetworkManager.requestCallCount, 3)
        XCTAssertTrue(mockPresenter.fetchSuccessCalled)
        
        // Verify cache is being used
        XCTAssertGreaterThan(mockCacheManager.saveCallCount, 0)
    }
} 