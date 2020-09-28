//
//  CartModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 7/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
// MARK: - AddToCartModelJSON
struct AddToCartModelJSON: Codable {
    var data : Cart?
    var status: Bool?
    var errors: Errors?
}

struct Cart: Codable {
    let id: Int?
    let course: TrendCourse?
    let user: Profile?
    let price, discount, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, course, user, price, discount
        case createdAt = "created_at"
    }
}

struct getCartModelJSON: Codable {
    var data : [Cart]?
    var status: Bool?
    var errors: String?
}
