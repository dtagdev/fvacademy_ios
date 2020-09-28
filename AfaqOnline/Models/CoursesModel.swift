//
//  CoursesModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/21/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
// MARK: - CoursesModel
struct CoursesModel: Codable {
    var data: [TrendCourse]?
    var status: Bool?
    var errors: String?
}

// MARK: - MyCoursesModelJSON
struct MyCoursesModelJSON: Codable {
    var data: [MyCoursesData]?
    var status: Bool?
    var errors: String?
}

// MARK: - MyCoursesData
struct MyCoursesData: Codable {
    var id: Int?
    var name: String?
    var type: String?
    var datumDescription, details, level, time: String?
    var mainImage, price: String?
    var courseURL, discount, trend: String?
    var lang, categoryID, instractuerID: Int?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, type
        case datumDescription = "description"
        case details, level, time
        case mainImage = "main_image"
        case price
        case courseURL = "course_url"
        case discount, trend, lang
        case categoryID = "category_id"
        case instractuerID = "instractuer_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - CourseDetailsModel
struct CourseDetailsModel: Codable {
    var data: TrendCourse?
    var status: Bool?
    var errors: String?
}



// MARK: - RelatedCoursesModelJSON
struct RelatedCoursesModelJSON: Codable {
    var data: [TrendCourse]?
    var status: Bool?
    var errors: String?
}



// MARK: - AllCoursesModelJSON
struct AllCoursesModelJSON: Codable {
    var data: CoursesDataClass?
    var status: Bool?
    var errors: String?
}

// MARK: - DataClass
struct CoursesDataClass: Codable {
    let courses: [TrendCourse]?
    let paginate: Paginate?
}


struct Paginate: Codable {
    let total, count, perPage: Int?
    let nextPageURL, prevPageURL: String?
    let currentPage, totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case total, count
        case perPage = "per_page"
        case nextPageURL = "next_page_url"
        case prevPageURL = "prev_page_url"
        case currentPage = "current_page"
        case totalPages = "total_pages"
    }
}


