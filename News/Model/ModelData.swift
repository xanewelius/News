//
//  ModelData.swift
//  News
//
//  Created by Max Kuzmin on 28.08.2023.
//

import Foundation

struct ArticlesResponse: Codable {
    let articles: [Article]
}

struct DetailResponse: Codable {
    let detail: [Detail]
}

struct Article: Codable {
    let id: Int
    let publisher: String
    let description: String
    let url: String
    let image: String
    let publishedAt: String
}

struct Detail: Codable {
    let id: Int
    let image: String
    let like: Int
    let dislike: Int
    let following: Int
    let comment: Int
    let text: String
}
