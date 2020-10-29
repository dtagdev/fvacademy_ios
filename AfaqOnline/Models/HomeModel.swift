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
    let articles: [Article]?
    
    enum CodingKeys: String, CodingKey {
        case courses
        case categories, instructors, events,articles
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
     let name: String?
     let type, eventDescription: String?
     let details, level, time: String?
     let mainImage: String?
     let price: String?
     let eventURL, discount: String?
     let trend, lang: Int?
     let startDate, endDate: String?
     let rate : Double?
     let instructors: [User]?
     let contents: [Content]?
     let comments: [Comment]?
     let category: Category?
    
    enum CodingKeys: String, CodingKey {
            case id, name, type
            case eventDescription = "description"
            case details, level, time
            case mainImage = "main_image"
            case price
            case eventURL = "event_url"
            case discount, trend, lang
            case startDate = "start_date"
            case endDate = "end_date"
            case instructors, contents, comments, category,rate
    }
}
// MARK: - CommentElement
struct Comment: Codable {
    let id, eventID,articleID ,userID: Int?
    let comment, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "event_id"
        case userID = "user_id"
        case comment
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case articleID = "article_id"
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

// MARK: - Instractuer
struct User: Codable {
   let id: Int
     let firstName: String?
     let lastName: String?
     let title: String?
     let avatar: String?
     let job: String?
     let idNumber, medicalNumber, phone: String?
     let gender: String?
     let email: String?
     let isVerified: Int?
     let verifiedAt, emailVerifiedAt: String?
     let createdAt, updatedAt: String?
    
     enum CodingKeys: String, CodingKey {
         case id
         case firstName = "first_name"
         case lastName = "last_name"
         case title, avatar, job
         case idNumber = "id_number"
         case medicalNumber = "medical_number"
         case phone, gender, email
         case isVerified = "is_verified"
         case verifiedAt = "verified_at"
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
      let rate: Double?
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
    let isWishlist, isPurchased: Bool?
    let rate: Double?
    let requirements: [Requirement]?
    let chapters: [Chapter]?
    let instructor: Instructor?
    let category: Category?
    let rates : [Rate]?

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
        case isWishlist = "is_wishlist"
        case isPurchased = "is_purchased"
        case rate, requirements, chapters, instructor, category,rates
    }
}

// MARK: - Chapter
struct Chapter: Codable {
    let id: Int?
    let name: String?
    let createdAt: String?
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
    let videoURL: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, read
        case videoURL = "video_url"
        case createdAt = "created_at"
    }
}

struct Requirement: Codable {
    let name: String?
}

struct ProfileModelJSON: Codable {
    var data: User?
    var status: Bool?
    var errors: String?
}

struct Rate: Codable {
   let id, instructorID, userID, rateValue: Int?
    let comment: String?
    let createdAt, updatedAt: String?
    let user :User?

    enum CodingKeys: String, CodingKey {
        case id
        case instructorID = "instructor_id"
        case userID = "user_id"
        case rateValue = "rate_value"
        case comment,user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Article
struct Article: Codable {
    let id: Int?
    let title, details, mainImage: String?
    let lang: Int?
    let comments: [Comment]?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, details
        case mainImage = "main_image"
        case lang, comments
        case createdAt = "created_at"
    }
}
