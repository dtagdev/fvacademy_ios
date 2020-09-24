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
    let id, userID, courseID: Int?
    let course: TrendCourse?
    let user: User?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case courseID = "course_id"
        case course, user
        case createdAt = "created_at"
    }
}


// MARK: - AddWishlistModelJSON
struct AddWishlistModelJSON: Codable {
    var data,status: Bool?
    var errors: String?
}


// MARK: - RemoveFromWishListModelJSON
struct RemoveFromWishListModelJSON: Codable {
    var data, status: Bool?
    var errors: String?
}
