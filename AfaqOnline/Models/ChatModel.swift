//
//  ChatModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/24/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation


struct ChatModel {
    var senderImage: String?
    var senderName: String?
    var message: String?
    var readAt: String?
    var ReceiverFlag: Bool?
    var start_date: Date?
}
// MARK: - MessageJSONModel
struct MessageJSONModel: Codable {
    var data: ChatDataClass?
    var status: Bool?
    var errors: String?
}

// MARK: - DataClass
struct ChatDataClass: Codable {
    var id: Int?
    var body: String?
    var roomID, senderID: Int?
    var readedAt, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, body
        case roomID = "room_id"
        case senderID = "sender_id"
        case readedAt = "readed_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
// MARK: - RoomChatModelJSON
struct RoomChatModelJSON: Codable {
    var data: [ChatDataClass]?
    var status: Bool?
    var errors: String?
}
