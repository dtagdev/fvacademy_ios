//
//  InstructorsModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/21/20.
//  Copyright © 2020 Dtag. All rights reserved.
//


import Foundation

// MARK: - AllEventModelJSON
struct InstructorsModelJson: Codable {
    let data: InstructorsModel
     let status: Bool?
      let errors: String?
}



import Foundation
// MARK: - HomeModelJSON
struct InstructorsModel: Codable {
    let instructors: [Instructor]?
    let paginate: Paginate?
}


struct InstructorDetailsModelJSON: Codable {
    var data: Instructor?
    var status: Bool?
    var errors: String?
}
