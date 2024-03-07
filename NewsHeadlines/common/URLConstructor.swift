//
//  URLConstructor.swift
//  NewsHeadlines
//
//  Created by Micah Napier on 8/3/2024.
//

import Foundation

struct URLConstructor {
  let host = "https://newsapi.org/v2/top-headlines"
  let apiKey = "5f149efaa4da467a911497ced0a9c47f"
  
  func urlForArticle(sources: [String]) -> URL? {
    var urlString = "\(host)?"
    
    if sources.isEmpty {
      urlString.append("country=us")
    } else {
      let sources = sources.joined(separator: ",")
      urlString.append("sources=\(sources)")
    }
    urlString.append("&apiKey=\(apiKey)")
    
    return URL(string: urlString)
  }
  
  func urlForSources() -> URL? {
    let urlString = "\(host)/sources?language=en&apiKey=\(apiKey)"
    return URL(string: urlString)
  }
}
