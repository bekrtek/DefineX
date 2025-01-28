//
//  Entity.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

// MARK: - Response Wrapper
struct DiscoveryResponse: Codable {
    let isSuccess: Bool
    let message: String
    let statusCode: Int?
    let list: [ProductModel]
}

// MARK: - Entity
struct ProductModel: Codable {
    let imageUrl: String
    let description: String
    let price: Price
    let oldPrice: Price?
    let discount: String
    let ratePercentage: Int?
}

struct Price: Codable {
    let value: Double
    let currency: String
}
