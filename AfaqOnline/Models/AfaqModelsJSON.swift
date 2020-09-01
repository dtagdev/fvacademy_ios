//
//  AfaqModelsJSON.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/18/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation

// MARK: - AfaqModelsJSON
struct AfaqModelsJSON: Codable {
    var status: Bool?
    var data: DataClass?
    var email: [String]?
    var errors: Errors?
}

// MARK: - DataClass
struct DataClass: Codable {
    var id: Int?
    var name, email, token: String?
    var role: Int?
    var accessToken, tokenType: String?
    var expiresIn: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, email, token, role
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}


// MARK: - LoginModelJSON
struct LoginModelJSON: Codable {
    var status: Bool?
    var data: LoginDataClass?
    var email: [String]?
    var errors: String?
}
// MARK: - DataClass
struct LoginDataClass: Codable {
    var id: Int?
    var firstName, lastName, email, title: String?
    var job, phone, gender, token: String?
    var role: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, title, job, phone, gender, token, role
    }
}
// MARK: - RateModelJSON
struct RateModelJSON: Codable {
    var status: Bool?
}
