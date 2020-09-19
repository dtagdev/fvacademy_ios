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
    var data: [Category]?
    var status: Bool?
    var errors: String?
}

