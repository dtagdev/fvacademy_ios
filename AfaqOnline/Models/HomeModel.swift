//
//  HomeModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/22/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation

// MARK: - CourseDetailsModel
struct HomeModelJSON: Codable {
    var data: HomeDataClass?
    var status: Bool?
    var errors: String?
}

// MARK: - DataClass
struct HomeDataClass: Codable {
    var trendCourses: [CoursesData]?
    var categories: [Category]?
    var instructores: [Instructore]?

    enum CodingKeys: String, CodingKey {
        case trendCourses = "trend_courses"
        case categories, instructores
    }
}

// MARK: - Category
struct Category: Codable {
    var id: Int?
    var name, img: String?
    var lang: Int?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, img, lang
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Instructore
struct Instructore: Codable {
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

// MARK: - UserData
struct UserData: Codable {
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


//MARK:- Profile Model
struct ProfileModelJSON: Codable {
    var data: UserData?
    var status: Bool?
    var errors: String?
}
