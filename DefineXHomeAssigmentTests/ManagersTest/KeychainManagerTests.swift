import XCTest
@testable import DefineXHomeAssigment

final class KeychainManagerTests: XCTestCase {
    var sut: KeychainManager!
    let testKey = "test_key"
    let testValue = "test_value"
    
    override func setUp() {
        super.setUp()
        sut = KeychainManager.shared
        // Clean up any existing test data
        try? sut.delete(testKey)
    }
    
    override func tearDown() {
        // Clean up test data
        try? sut.delete(testKey)
        sut = nil
        super.tearDown()
    }
    
    func testSharedInstance() {
        // Given
        let instance1 = KeychainManager.shared
        let instance2 = KeychainManager.shared
        
        // Then
        XCTAssertTrue(instance1 === instance2, "Shared instances should be identical")
    }
    
    func testSaveAndGetValue() throws {
        // When
        try sut.save(testValue, for: testKey)
        
        // Then
        let retrievedValue = try sut.get(testKey)
        XCTAssertEqual(retrievedValue, testValue)
    }
    
    func testUpdateValue() throws {
        // Given
        try sut.save(testValue, for: testKey)
        let newValue = "updated_value"
        
        // When
        try sut.update(newValue, for: testKey)
        
        // Then
        let retrievedValue = try sut.get(testKey)
        XCTAssertEqual(retrievedValue, newValue)
    }
    
    func testDeleteValue() throws {
        // Given
        try sut.save(testValue, for: testKey)
        
        // When
        try sut.delete(testKey)
        
        // Then
        XCTAssertThrowsError(try sut.get(testKey)) { error in
            XCTAssertTrue(error is KeychainManager.KeychainError)
            XCTAssertEqual(error as? KeychainManager.KeychainError, .notFound)
        }
    }
    
    func testGetNonExistentValue() {
        // Then
        XCTAssertThrowsError(try sut.get("non_existent_key")) { error in
            XCTAssertTrue(error is KeychainManager.KeychainError)
            XCTAssertEqual(error as? KeychainManager.KeychainError, .notFound)
        }
    }
    
    func testSaveDuplicateValue() throws {
        // Given
        try sut.save(testValue, for: testKey)
        let newValue = "new_value"
        
        // When
        try sut.save(newValue, for: testKey)
        
        // Then
        let retrievedValue = try sut.get(testKey)
        XCTAssertEqual(retrievedValue, newValue, "Saving duplicate should update the value")
    }
    
    func testUpdateNonExistentValue() {
        // Then
        XCTAssertThrowsError(try sut.update(testValue, for: "non_existent_key")) { error in
            XCTAssertTrue(error is KeychainManager.KeychainError)
        }
    }
    
    func testDeleteNonExistentValue() {
        // Then
        XCTAssertNoThrow(try sut.delete("non_existent_key"), "Deleting non-existent key should not throw")
    }
    
    func testSaveEmptyString() throws {
        // Given
        let emptyValue = ""
        
        // When
        try sut.save(emptyValue, for: testKey)
        
        // Then
        let retrievedValue = try sut.get(testKey)
        XCTAssertEqual(retrievedValue, emptyValue)
    }
} 