//
//  PasswordModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 7/12/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
// MARK: - ForgetPasswordModel
struct PasswordJSONModel: Codable {
    var data, status: Bool?
    var errors: String?
}

struct PasswordUpdatJSONModel: Codable {
    var data : User?
    var status: Bool?
    var errors: String?
}

