//
//  CategoriesModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/21/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation

// MARK: - CategoriesModel
struct CategoriesModel: Codable {
    var data: [CategoryData]?
    var status: Bool?
    var errors: String?
}

// MARK: - Datum
struct CategoryData: Codable {
    var id: Int?
    var name, img: String?
    var createdAt, updatedAt: String?
    var selected: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, img
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case selected
    }
}
