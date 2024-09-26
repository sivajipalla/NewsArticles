//
//  ArticlesModel.swift
//  News Task
//
//  Created by Sivaji Palla on 24/09/24.
//

import Foundation

//MARK: - Articel Response Model
struct ArticleResponse: Codable {
    let articles: [Article]
}

//MARK: - Article Model
struct Article: Codable {
    let source: Source
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?

    enum CodingKeys: String, CodingKey {
        case source
        case title
        case description
        case url
        case urlToImage
        case publishedAt
    }
}

// MARK: - Source Model
struct Source: Codable {
    let id, name: String?
}

