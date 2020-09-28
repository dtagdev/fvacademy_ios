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
     let name: String?
     let type, eventDescription: String?
     let details, level, time: String?
     let mainImage: String?
     let price: String?
     let eventURL, discount: String?
     let trend, lang: Int?
     let startDate, endDate: String?
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
            case instructors, contents, comments, category
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
    let instructor: ContentInstructor?

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

// MARK: - ContentInstructor
struct ContentInstructor: Codable {
    let id: Int?
    let image: String?
    let lang: Int?
    let details: String?
    let categoryID, userID: Int?
    let createdAt, updatedAt: String?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id, image, lang, details
        case categoryID = "category_id"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
    }
}


// MARK: - Instractuer
struct User: Codable {
   let id: Int
     let firstName: FirstName?
     let lastName: LastName?
     let title: FirstName?
     let avatar: String?
     let job: Job?
     let idNumber, medicalNumber, phone: String?
     let gender: Gender?
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


enum FirstName: String, Codable {
    case instructor = "instructor"
    case magdi = "Magdi"
    case moamena = "Moamena"
    case reem = "reem"
}

enum Gender: String, Codable {
    case female = "female"
    case male = "male"
}

enum Job: String, Codable {
    case drPsychological = "Dr. psychological"
    case heartSDoctor = "heart's doctor"
    case instructor = "instructor"
    case labDoctor = "Lab Doctor"
}

enum LastName: String, Codable {
    case farg = "farg"
    case instructor = "instructor"
    case kamel = "Kamel"
    case yacoub = "Yacoub"
}

// MARK: - Instructor
struct Instructor: Codable {
    let id: Int?
      let image: String?
      let lang: Int?
      let details: String?
      let category: Category?
      let user: User?
      let rate: RateUnion?
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
    let rate: Int?
    let requirements: [Requirement]?
    let chapters: [Chapter]?
    let instructor: Instructor?
    let category: Category?

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
        case rate, requirements, chapters, instructor, category
    }
}

// MARK: - Chapter
struct Chapter: Codable {
    let id: Int?
    let name: String?
    let createdAt: ChapterCreatedAt?
    let lessons: [Lesson]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case lessons
    }
}

enum ChapterCreatedAt: String, Codable {
    case the202008101008Am = "2020-08-10 10:08 am"
    case the202009271208Pm = "2020-09-27 12:08 pm"
    case the20200927153Am = "2020-09-27 1:53 am"
}

// MARK: - Lesson
struct Lesson: Codable {
    let id: Int?
    let name: String?
    let read: Int?
    let videoURL: String?
    let createdAt: LessonCreatedAt?

    enum CodingKeys: String, CodingKey {
        case id, name, read
        case videoURL = "video_url"
        case createdAt = "created_at"
    }
}

enum LessonCreatedAt: String, Codable {
    case the202008101008Am = "2020-08-10 10:08 am"
    case the202008101208Pm = "2020-08-10 12:08 pm"
    case the20200927153Am = "2020-09-27 1:53 am"
}

struct Requirement: Codable {
    let name: String?
}

struct ProfileModelJSON: Codable {
    var data: Profile?
    var status: Bool?
    var errors: String?
}

struct Rate: Codable {
   let id, instructorID, userID, rateValue: Int?
    let comment: String?
    let createdAt, updatedAt: String?

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

struct Profile: Codable {
    let isVerified: Int?
    let idNumber, email, gender, firstName: String?
    let avatar: String?
    let title, medicalNumber, job: String
    let emailVerifiedAt: String?
    let verifiedAt, updatedAt, createdAt, lastName: String?
    let id: Int?
    let phone: String?

    enum CodingKeys: String, CodingKey {
        case isVerified = "is_verified"
        case idNumber = "id_number"
        case email, gender
        case firstName = "first_name"
        case avatar, title
        case medicalNumber = "medical_number"
        case job
        case emailVerifiedAt = "email_verified_at"
        case verifiedAt = "verified_at"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case lastName = "last_name"
        case id, phone
    }
}

enum RateUnion: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(RateUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for RateUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
