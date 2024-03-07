//
//  NetworkActor.swift
//  NewsHeadlines
//
//  Created by Micah Napier on 8/3/2024.
//

import Foundation

protocol ArticleFetcher {
  func getArticles(for sources: [String]) async throws -> [Article]?
  func getSources() async throws -> [ArticleSource]?
}

actor NetworkActor: ArticleFetcher {
  
  func getArticles(for sources: [String]) async throws -> [Article]? {
    guard let articleURL = URLConstructor().urlForArticle(sources: sources) else {
      throw ArticleError.invalidURL
    }
    
    do {
      let (data, _) = try await URLSession.shared.data(from: articleURL)
      let articleContainer = try JSONDecoder().decode(ArticleContainer.self, from: data)
      
      return articleContainer.articles
        
    } catch {
      debugPrint("Error loading \(articleURL): \(String(describing: error))")
    }
    return nil
  }
  
  func getSources() async throws -> [ArticleSource]? {
    guard let sourcesURL = URLConstructor().urlForSources() else {
      throw ArticleError.invalidURL
    }
    
    do {
      let (data, _) = try await URLSession.shared.data(from: sourcesURL)
      let articleSourceContainer = try JSONDecoder().decode(ArticleSourceContainer.self, from: data)
      
      return articleSourceContainer.sources
        
    } catch {
      debugPrint("Error loading \(sourcesURL): \(String(describing: error))")
    }
    return nil
  }
}
