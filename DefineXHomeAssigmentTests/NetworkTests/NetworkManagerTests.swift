import XCTest
@testable import DefineXHomeAssigment

final class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager!
    var mockCacheManager: MockCacheManager!
    
    override func setUp() {
        super.setUp()
        mockCacheManager = MockCacheManager()
        sut = NetworkManager(cacheManager: mockCacheManager)
    }
    
    override func tearDown() {
        mockCacheManager = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Test Models
    struct MockResponse: Codable, Equatable {
        let id: Int
        let title: String
    }
    
    // MARK: - Mock Cache Manager
    class MockCacheManager: CacheManagerProtocol {
        var savedData: [String: Any] = [:]
        var loadCallCount = 0
        var saveCallCount = 0
        var shouldThrowOnLoad = false
        
        func save<T>(_ data: T, forKey key: String) throws where T : Encodable {
            savedData[key] = data
            saveCallCount += 1
        }
        
        func load<T>(forKey key: String) throws -> T where T : Decodable {
            loadCallCount += 1
            if shouldThrowOnLoad {
                throw NSError(domain: "MockError", code: -1)
            }
            guard let data = savedData[key] as? T else {
                throw NSError(domain: "MockError", code: -1)
            }
            return data
        }
    }
    
    // MARK: - Success Tests
    func testSuccessfulRequest() {
        // Given
        let expectation = XCTestExpectation(description: "Network request completed")
        let endpoint = Endpoint(
            path: "/posts/1",
            method: .get,
            baseURL: URL(string: "https://jsonplaceholder.typicode.com")!
        )
        
        // When
        sut.request(endpoint: endpoint, responseType: MockResponse.self, useCache: false) { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response.id, 1)
                XCTAssertFalse(response.title.isEmpty)
            case .failure(let error):
                XCTFail("Request should succeed, got error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCachedResponse() {
        // Given
        let expectation = XCTestExpectation(description: "Cached response retrieved")
        let endpoint = Endpoint(
            path: "/test",
            method: .get
        )
        let mockResponse = MockResponse(id: 1, title: "Cached")
        let cacheKey = "\(endpoint.path)_\(endpoint.method.rawValue)"
        try? mockCacheManager.save(mockResponse, forKey: cacheKey)
        
        // When
        sut.request(endpoint: endpoint, responseType: MockResponse.self, useCache: true) { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response, mockResponse)
                XCTAssertEqual(self.mockCacheManager.loadCallCount, 1)
            case .failure(let error):
                XCTFail("Should retrieve cached response, got error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCacheMissFollowedByNetworkRequest() {
        // Given
        let expectation = XCTestExpectation(description: "Cache miss followed by network request")
        let endpoint = Endpoint(
            path: "/posts/1",
            method: .get,
            baseURL: URL(string: "https://jsonplaceholder.typicode.com")!
        )
        mockCacheManager.shouldThrowOnLoad = true
        
        // When
        sut.request(endpoint: endpoint, responseType: MockResponse.self, useCache: true) { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response.id, 1)
                XCTAssertFalse(response.title.isEmpty)
                XCTAssertEqual(self.mockCacheManager.loadCallCount, 1)
            case .failure(let error):
                XCTFail("Request should succeed after cache miss, got error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Error Tests
    func testInvalidURLError() {
        // Given
        let expectation = XCTestExpectation(description: "Invalid URL error")
        let endpoint = Endpoint(
            path: "\\invalid\\url",
            method: .get
        )
        
        // When
        sut.request(endpoint: endpoint, responseType: MockResponse.self, useCache: false) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fail with invalid URL")
            case .failure(let error):
                XCTAssertEqual(error, .invalidURL)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUnauthorizedError() {
        // Given
        let expectation = XCTestExpectation(description: "Unauthorized error")
        let endpoint = Endpoint(
            path: "/401",
            method: .get,
            baseURL: URL(string: "https://httpstat.us")!
        )
        
        // When
        sut.request(endpoint: endpoint, responseType: MockResponse.self, useCache: false) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fail with unauthorized")
            case .failure(let error):
                XCTAssertEqual(error, .unauthorized)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testServerError() {
        // Given
        let expectation = XCTestExpectation(description: "Server error")
        let endpoint = Endpoint(
            path: "/500",
            method: .get,
            baseURL: URL(string: "https://httpstat.us")!
        )
        
        // When
        sut.request(endpoint: endpoint, responseType: MockResponse.self, useCache: false) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fail with server error")
            case .failure(let error):
                if case .serverError = error {
                    // Success
                } else {
                    XCTFail("Expected server error, got \(error)")
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDecodingError() {
        // Given
        let expectation = XCTestExpectation(description: "Decoding error")
        let endpoint = Endpoint(
            path: "/200",
            method: .get,
            baseURL: URL(string: "https://httpstat.us")!
        )
        
        // When
        sut.request(endpoint: endpoint, responseType: MockResponse.self, useCache: false) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fail with decoding error")
            case .failure(let error):
                XCTAssertEqual(error, .decodingError)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
} 