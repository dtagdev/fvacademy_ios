//
//  SuccessErrorModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/18/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation

// MARK: - Errors
struct Errors: Codable {
    var email: [String]?
    var courseID: [String]?
    var comment: [String]?
    var price: [String]?
    enum CodingKeys: String, CodingKey {
        case courseID = "course_id"
        case email
        case comment
        case price
    }
}
