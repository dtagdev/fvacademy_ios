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
    var data, status: Bool?
    var errors: Errors?
}
