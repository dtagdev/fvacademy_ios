//  CoursesModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/21/20.
//  Copyright © 2020 Dtag. All rights reserved.
//


import Foundation

// MARK: - AllEventModelJSON
struct AllEventModelJSON: Codable {
    let data: EventDataClass
    let status: Bool
    let errors: String?
}

// MARK: - DataClass
struct EventDataClass: Codable {
    let events: [Event]?
    let paginate: Paginate?
}


// MARK: - EventDetailsModelJSON
struct EventDetailsModelJSON: Codable {
    let data: Event?
    let status: Bool?
    let errors: String?
}

