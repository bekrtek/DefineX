import XCTest
@testable import DefineXHomeAssigment

final class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager!
    var mockCacheManager: MockCacheManager!
    var mockURLSession: URLSession!
    
    // MARK: - URLProtocolMock
    class URLProtocolMock: URLProtocol {
        static var mockData: Data?
        static var mockResponse: URLResponse?
        static var mockError: Error?
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let error = URLProtocolMock.mockError {
                client?.urlProtocol(self, didFailWithError: error)
                return
            }
            
            if let response = URLProtocolMock.mockResponse {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let data = URLProtocolMock.mockData {
                client?.urlProtocol(self, didLoad: data)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
        
        static func reset() {
            mockData = nil
            mockResponse = nil
            mockError = nil
        }
    }
    
    override func setUp() {
        super.setUp()
        mockCacheManager = MockCacheManager()
        
        // Configure URLSession with mock protocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        mockURLSession = URLSession(configuration: config)
        
        sut = NetworkManager(cacheManager: mockCacheManager, urlSession: mockURLSession)
    }
    
    override func tearDown() {
        URLProtocolMock.reset()
        mockCacheManager = nil
        mockURLSession = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Test Models
    struct MockResponse: Codable, Equatable {
        let id: Int
        let title: String
    }
    
    // MARK: - Mock Endpoint
    struct MockEndpoint: Endpoint {
        var path: String
        var method: HTTPMethod
        var headers: [String: String]?
        var body: [String: Any]?
        
        init(path: String, method: HTTPMethod = .get, headers: [String: String]? = nil, body: [String: Any]? = nil) {
            self.path = path
            self.method = method
            self.headers = headers
            self.body = body
        }
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
        let endpoint = MockEndpoint(
            path: "/posts/1",
            method: .get,
            headers: ["Content-Type": "application/json"]
        )
        
        // Mock successful response
        let mockResponse = MockResponse(id: 1, title: "Test Title")
        let jsonData = try! JSONEncoder().encode(mockResponse)
        URLProtocolMock.mockData = jsonData
        URLProtocolMock.mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        sut.request(endpoint: endpoint, responseType: MockResponse.self, useCache: false) { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response.id, 1)
                XCTAssertEqual(response.title, "Test Title")
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
        let endpoint = MockEndpoint(path: "/test", method: .get)
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
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCacheMissFollowedByNetworkRequest() {
        // Given
        let expectation = XCTestExpectation(description: "Cache miss followed by network request")
        let endpoint = MockEndpoint(
            path: "/posts/1",
            method: .get,
            headers: ["Content-Type": "application/json"]
        )
        mockCacheManager.shouldThrowOnLoad = true
        
        // Mock successful response
        let mockResponse = MockResponse(id: 1, title: "Network Response")
        let jsonData = try! JSONEncoder().encode(mockResponse)
        URLProtocolMock.mockData = jsonData
        URLProtocolMock.mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        sut.request(endpoint: endpoint, responseType: MockResponse.self, useCache: true) { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response.id, 1)
                XCTAssertEqual(response.title, "Network Response")
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
        let endpoint = MockEndpoint(path: "\\invalid\\url", method: .get)
        
        // When
        sut.request(endpoint: endpoint, responseType: MockResponse.self, useCache: false) { result in
            // Then
            if case .failure(let error) = result {
                XCTAssertTrue(error == .invalidURL)
            } else {
                XCTFail("Request should fail with invalid URL")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUnauthorizedError() {
        // Given
        let expectation = XCTestExpectation(description: "Unauthorized error")
        let endpoint = MockEndpoint(path: "/401", method: .get)
        
        // Mock 401 response
        URLProtocolMock.mockData = Data()
        URLProtocolMock.mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        sut.request(endpoint: endpoint, responseType: MockResponse.self, useCache: false) { result in
            // Then
            if case .failure(let error) = result {
                XCTAssertEqual(error, .unauthorized)
            } else {
                XCTFail("Request should fail with unauthorized")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
