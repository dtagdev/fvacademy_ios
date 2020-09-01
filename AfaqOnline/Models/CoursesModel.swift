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
    var data: [CoursesData]?
    var status: Bool?
    var errors: String?
}

// MARK: - Datum
struct CoursesData: Codable {
    var id: Int?
    var name, type, dataDescription, details: String?
    var level, time, mainImage, price: String?
    var courseURL, discount, trend: String?
    var lang, isWishlist, isPurchased: Int?
    var rate: Double?
    var requirments: [Requirment]?
    var chapters: [Chapter]?

    enum CodingKeys: String, CodingKey {
        case id
        case name, type
        case dataDescription = "description"
        case details, level, time
        case mainImage = "main_image"
        case price
        case courseURL = "course_url"
        case discount, trend, lang
        case isWishlist = "is_wishlist"
        case isPurchased = "is_purchased"
        case rate, requirments, chapters
    }
}
// MARK: - Chapter
struct Chapter: Codable {
    var id: Int?
    var name: Name?
    var createdAt: String?
    var lessons: [Chapter]?
    var videoURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case lessons
        case videoURL = "video_url"
    }
}

enum Name: String, Codable {
    case afsdFdsaf = "['afsd', 'fdsaf']"
    case test = "test"
    case text = "text"
}

// MARK: - Requirment
struct Requirment: Codable {
    var name: String?
}

// MARK: - AllCoursesModelJSON
struct AllCoursesModelJSON: Codable {
    var data: CoursesDataClass?
    var status: Bool?
    var errors: String?
}

// MARK: - DataClass
struct CoursesDataClass: Codable {
    var currentPage: Int?
    var data: [CoursesData]?
    var firstPageURL: String?
    var from, lastPage: Int?
    var lastPageURL: String?
    var nextPageURL: String?
    var path: String?
    var perPage, prevPageURL: String?
    var to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - CourseDetailsModel
struct CourseDetailsModel: Codable {
    var data: CoursesData?
    var status: Bool?
    var errors: String?
}



// MARK: - RelatedCoursesModelJSON
struct RelatedCoursesModelJSON: Codable {
    var data: [CoursesData]?
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
