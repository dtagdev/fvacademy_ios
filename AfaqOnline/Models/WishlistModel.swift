//
//  WishlistModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/22/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation

// MARK: - WishlistModelJSON
struct WishlistModelJSON: Codable {
    var data: [WishlistData]?
    var status: Bool?
    var errors: String?
}

// MARK: - Datum
struct WishlistData: Codable {
    var id, userID, cousreID: Int?
    var createdAt, updatedAt: String?
    var courseData: CourseData?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case cousreID = "cousre_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case courseData = "course_data"
    }
}

// MARK: - CourseData
struct CourseData: Codable {
    var id: Int?
    var name, details, image, price: String?
}
// MARK: - AddWishlistModelJSON
struct AddWishlistModelJSON: Codable {
    var data: AddWishlistData?
    var status: Bool?
    var errors: String?
}

// MARK: - DataClass
struct AddWishlistData: Codable {
    var userID, cousreID, updatedAt, createdAt: String?
    var id: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case cousreID = "cousre_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
// MARK: - RemoveFromWishListModelJSON
struct RemoveFromWishListModelJSON: Codable {
    var data, status: Bool?
    var errors: String?
}
