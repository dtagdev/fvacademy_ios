//
//  HomeModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/22/20.
//  Copyright © 2020 Dtag. All rights reserved.
//




import Foundation

// MARK: - HomeModelJSON
struct HomeModelJSON: Codable {
    let data: HomeDataClass?
    let status: Bool?
    let errors: String?
}

// MARK: - DataClass
struct HomeDataClass: Codable {
    let courses: [TrendCourse]?
    let categories: [Category]?
    let instructors: [Instructor]?
    let events: [Event]?

    enum CodingKeys: String, CodingKey {
        case courses
        case categories, instructors, events
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name, image: String?
    let lang: Int?
    let createdAt: String?
    var selected: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, image, lang
        case createdAt = "created_at"
        case selected
    }


}

// MARK: - Event
struct Event: Codable {
    let id: Int?
    let name, eventDescription, details, level: String?
    let time, mainImage, price: String?
    let eventURL, discount: String?
    let startDate, endDate: String?
    let trend, lang, categoryID, instractuerID: Int?
    let createdAt, updatedAt: String?
    let instructors: [User]?
    let comments: [Comment]?
    let contents: [Content]?
    let category: Category?
    


    enum CodingKeys: String, CodingKey {
        case id, name
        case eventDescription = "description"
        case details, level, time
        case mainImage = "main_image"
        case price
        case eventURL = "event_url"
        case discount
        case startDate = "start_date"
        case endDate = "end_date"
        case trend, lang
        case categoryID = "category_id"
        case instractuerID = "instractuer_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case instructors,comments,category,contents
    }

}

// MARK: - Content
struct Content: Codable {
    let id: Int?
    let title, startTime, endTime: String?
    let live, eventID, instructorID: Int?
    let createdAt, updatedAt: String?
    let instructor: Instructor?

    enum CodingKeys: String, CodingKey {
        case id, title
        case startTime = "start_time"
        case endTime = "end_time"
        case live
        case eventID = "event_id"
        case instructorID = "instructor_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case instructor
    }
}

struct Comment: Codable {
    let id, eventID, userID: Int?
    let comment, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "event_id"
        case userID = "user_id"
        case comment
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


// MARK: - Instractuer
struct User: Codable {
    let id: Int?
    let firstName, lastName, title, job: String?
    let idNumber, medicalNumber, phone, gender: String?
    let email: String?
    let emailVerifiedAt: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case title, job
        case idNumber = "id_number"
        case medicalNumber = "medical_number"
        case phone, gender, email
        case emailVerifiedAt = "email_verified_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Instructor
struct Instructor: Codable {
    let id: Int?
       let image: String?
       let lang: Int?
       let details: String?
       let category: Category?
       let user: User?
       let rate: String?
       let rates: [Rate]?
       let courses: [TrendCourse]?
    }

// MARK: - TrendCourse
struct TrendCourse: Codable {
    let id: Int?
    let name, type, courseDescription, details: String?
    let level, time, mainImage, price: String?
    let courseURL: String?
    let discount: String?
    let trend: Int?
    let lang: Int?
    let startDate, endDate: String?
    let categoryID, instructorID, status: Int?
    let createdAt, updatedAt: String?
    let isWishlist, isPurchased: Bool?
    let rate: Int?
    let chapters: [Chapter]?
    let instructor: Instructor?

    enum CodingKeys: String, CodingKey {
       case id, name, type
          case courseDescription = "description"
          case details, level, time
          case mainImage = "main_image"
          case price
          case courseURL = "course_url"
          case discount, trend, lang
          case startDate = "start_date"
          case endDate = "end_date"
          case categoryID = "category_id"
          case instructorID = "instructor_id"
          case status
          case createdAt = "created_at"
          case updatedAt = "updated_at"
          case isWishlist = "is_wishlist"
          case isPurchased = "is_purchased"
         case rate, chapters, instructor
    }
}
// MARK: - Chapter
struct Chapter: Codable {
    let id: Int?
    let name, createdAt: String?
    let lessons: [Lesson]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case lessons
    }
}

// MARK: - Lesson
struct Lesson: Codable {
    let id: Int?
    let name: String?
    let read: Int?
    let videoURL, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, read
        case videoURL = "video_url"
        case createdAt = "created_at"
    }
}




struct ProfileModelJSON: Codable {
    var data: User?
    var status: Bool?
    var errors: String?
}

struct Rate: Codable {
    let id, instructorID, userID, rateValue: Int?
    let comment, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case instructorID = "instructor_id"
        case userID = "user_id"
        case rateValue = "rate_value"
        case comment
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
