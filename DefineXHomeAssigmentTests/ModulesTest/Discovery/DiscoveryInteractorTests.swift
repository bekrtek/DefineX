import XCTest
@testable import DefineXHomeAssigment

@MainActor
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
                    } else {
                        completion(.failure(.decodingError))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            } else {
                completion(.failure(.serverError("No mock response set for endpoint: \(endpoint.path)")))
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
                imageUrl: "https://example.com/image\(index).jpg",
                description: "\(prefix)_product_\(index)",
                price: Price(value: Double(index * 10), currency: "$"),
                oldPrice: Price(value: Double(index * 15), currency: "$"),
                discount: "\(index * 10)% OFF",
                ratePercentage: index * 20
            )
        }
    }
    
    // MARK: - Tests
    func testFetchDiscoveryDataSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch discovery data success")
        let firstList = createMockProducts(count: 3, prefix: "first")
        let secondList = createMockProducts(count: 4, prefix: "second")
        let twoColumnList = createMockProducts(count: 6, prefix: "column")
        
        mockNetworkManager.setupMockResponses(
            firstList: .success(DiscoveryResponse(
                isSuccess: true,
                message: "Success",
                statusCode: 200,
                list: firstList
            )),
            secondList: .success(DiscoveryResponse(
                isSuccess: true,
                message: "Success",
                statusCode: 200,
                list: secondList
            )),
            twoColumnList: .success(DiscoveryResponse(
                isSuccess: true,
                message: "Success",
                statusCode: 200,
                list: twoColumnList
            ))
        )
        
        // When
        sut.fetchDiscoveryData()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.mockNetworkManager.requestCallCount, 3)
            XCTAssertTrue(self.mockPresenter.fetchSuccessCalled)
            XCTAssertEqual(self.mockPresenter.lastFirstList?.count, firstList.count)
            XCTAssertEqual(self.mockPresenter.lastSecondList?.count, secondList.count)
            XCTAssertEqual(self.mockPresenter.lastTwoColumnList?.count, twoColumnList.count)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchDiscoveryDataPartialFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch discovery data partial failure")
        let firstList = createMockProducts(count: 3, prefix: "first")
        mockNetworkManager.setupMockResponses(
            firstList: .success(DiscoveryResponse(
                isSuccess: true,
                message: "Success",
                statusCode: 200,
                list: firstList
            )),
            secondList: .failure(.serverError("Error")),
            twoColumnList: .success(DiscoveryResponse(
                isSuccess: true,
                message: "Success",
                statusCode: 200,
                list: []
            ))
        )
        
        // When
        sut.fetchDiscoveryData()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.mockNetworkManager.requestCallCount, 3)
            XCTAssertTrue(self.mockPresenter.fetchFailureCalled)
            XCTAssertNotNil(self.mockPresenter.lastError)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchDiscoveryDataAllFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch discovery data all failure")
        mockNetworkManager.setupMockResponses(
            firstList: .failure(.serverError("Error 1")),
            secondList: .failure(.serverError("Error 2")),
            twoColumnList: .failure(.serverError("Error 3"))
        )
        
        // When
        sut.fetchDiscoveryData()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.mockNetworkManager.requestCallCount, 3)
            XCTAssertTrue(self.mockPresenter.fetchFailureCalled)
            XCTAssertNotNil(self.mockPresenter.lastError)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchDiscoveryDataEmptyLists() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch discovery data empty lists")
        mockNetworkManager.setupMockResponses(
            firstList: .success(DiscoveryResponse(
                isSuccess: true,
                message: "Success",
                statusCode: 200,
                list: []
            )),
            secondList: .success(DiscoveryResponse(
                isSuccess: true,
                message: "Success",
                statusCode: 200,
                list: []
            )),
            twoColumnList: .success(DiscoveryResponse(
                isSuccess: true,
                message: "Success",
                statusCode: 200,
                list: []
            ))
        )
        
        // When
        sut.fetchDiscoveryData()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.mockNetworkManager.requestCallCount, 3)
            XCTAssertTrue(self.mockPresenter.fetchSuccessCalled)
            XCTAssertEqual(self.mockPresenter.lastFirstList?.count, 0)
            XCTAssertEqual(self.mockPresenter.lastSecondList?.count, 0)
            XCTAssertEqual(self.mockPresenter.lastTwoColumnList?.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
} 
