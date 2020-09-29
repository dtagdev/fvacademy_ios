//
//  AboutApp.swift
//  AfaqOnline
//
//  Created by MAC on 9/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation

// MARK: - AboutApp
struct AboutAppModelJSON: Codable {
    let data: AboutAppData?
    let status: Bool?
    let errors: String?
}

// MARK: - DataClass
struct AboutAppData: Codable {
    let id: Int?
    let aboutUs, termsConditions, privacyPolicy: String?
    let lang: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case aboutUs = "about_us"
        case termsConditions = "terms_conditions"
        case privacyPolicy = "privacy_policy"
        case lang
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
// MARK: - AboutApp
struct ContactUsModelJSON : Codable {
    let data: ContactUsData?
    let status: Bool?
    let errors: String?
}

// MARK: - DataClass
struct ContactUsData: Codable {
    let id: Int?
    let address, phone, email, lat: String?
    let lng: String?
    let lang: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, address, phone, email, lat, lng, lang
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

