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
    let id: Int?
    let firstName, lastName, email, title: String?
    let job, phone: String?
    let isVerified: Int?
    let verifiedAt: String?
    let gender, token: String?
    let role: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, title, job, phone
        case isVerified = "is_verified"
        case verifiedAt = "verified_at"
        case gender, token, role
    }
}


// MARK: - LoginModelJSON
struct LoginModelJSON: Codable {
    var status: Bool?
    var data: DataClass?
    var email: [String]?
    var errors: String?
}

// MARK: - RateModelJSON
struct RateModelJSON: Codable {
    var status: Bool?
}




