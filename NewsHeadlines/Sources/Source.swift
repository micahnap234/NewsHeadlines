//
//  Source.swift
//  NewsHeadlines
//
//  Created by Micah Napier on 8/3/2024.
//

import Foundation

struct ArticleSource: Codable {
  let id: String?
  let name: String?
  let description: String?
  var isPreferred: Bool?
}

struct ArticleSourceContainer: Decodable {
  let status: String?
  let sources: [ArticleSource]?
}
