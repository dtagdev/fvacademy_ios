//
//  CommentsModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 7/24/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
// MARK: - CommentsModelJSON
struct CommentsModelJSON: Codable {
    var data: [CommentData]?
    var status: Bool?
    var errors: Errors?
}

// MARK: - Datum
struct CommentData: Codable {
    var id, courseID, userID: Int?
    var comment, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case courseID = "course_id"
        case userID = "user_id"
        case comment
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
// MARK: - AddCommentModelJSON
struct AddCommentModelJSON: Codable {
    var data: CommentData?
    var status: Bool?
    var errors: Errors?
}
