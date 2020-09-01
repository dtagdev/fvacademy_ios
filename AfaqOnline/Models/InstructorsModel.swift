//
//  InstructorsModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/21/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation

// MARK: - InstructorsModel
struct InstructorsModel: Codable {
    var data: [InstructorsData]?
    var status: Bool?
    var errors: String?
}

// MARK: - Datum
struct InstructorsData: Codable {
    var id: Int?
    var image: String?
    var categoryID, instractuerID: Int?
    var createdAt, updatedAt: String?
    var userData: UserData?

    enum CodingKeys: String, CodingKey {
        case id, image
        case categoryID = "category_id"
        case instractuerID = "instractuer_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userData = "user_data"
    }
}

// MARK: - InstructorDetailsModelJSOn
struct InstructorDetailsModelJSON: Codable {
    var data: InstructorsData?
    var status: Bool?
    var errors: String?
}
// MARK: - Instructor
struct Instructor: Codable {
    var id: Int?
    var firstName, lastName, title, job: String?
    var idNumber, medicalNumber, phone, gender: String?
    var email, emailVerifiedAt, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case title, job
        case idNumber = "id_number"
        case medicalNumber = "medical_number"
        case phone, gender, email
        case emailVerifiedAt = "email_verified_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
