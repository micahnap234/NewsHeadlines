//
//  Article.swift
//  NewsHeadlines
//
//  Created by Micah Napier on 7/3/2024.
//

import Foundation

struct Article: Codable {
  let title: String?
  let source: ArticleSource?
  let author: String?
  let description: String?
  let url: URL?
  let urlToImage: URL?
}

struct ArticleContainer: Decodable {
  let status: String?
  let totalResults: Int?
  let articles: [Article]?
}
