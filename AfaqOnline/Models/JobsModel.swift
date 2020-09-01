//
//  JobsModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/21/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation

// MARK: - JobsModel
struct JobsModel: Codable {
    var data: [String]?
    var status: Bool?
    var errors: String?
}
