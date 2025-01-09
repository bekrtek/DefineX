//
//  Entity.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

// MARK: - Entity
struct LoginResponse: Codable {
    let isSuccess: Bool
    let message: String
    let statusCode: Int
    let token: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}
