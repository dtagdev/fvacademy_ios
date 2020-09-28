//
//  ArticalModel.swift
//  AfaqOnline
//
//  Created by MAC on 9/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation


// MARK: - AllEventModelJSON
struct AllArticalModelJSON: Codable {
    let data: ArticalData?
    let status: Bool?
    let errors: String?
}

// MARK: - DataClass
struct ArticalData: Codable {
    let articles: [Article]?
    let paginate: Paginate?
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



// MARK: - AllEventModelJSON
struct ArticaDetalislModelJSON: Codable {
    let data: ArticaDetalis?
    let status: Bool?
    let errors: String?
}

// MARK: - DataClass
struct ArticaDetalis: Codable {
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
