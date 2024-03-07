//
//  StorageActor.swift
//  NewsHeadlines
//
//  Created by Micah Napier on 9/3/2024.
//

import Foundation

protocol StorageHandler {
  func saveArticle(_ article: Article) async throws
  func saveSource(_ articleSource: ArticleSource) async throws
  func loadSavedArticles() async throws -> [Article]?
  func loadSavedSources() async throws -> [ArticleSource]?
  func saveArticles(articles: [Article]) async throws
}

enum StorageError: Error {
  case fileAlreadyExists
  case invalidDirectory
  case writtingFailed
}

actor StorageActor: StorageHandler {
  static let SavedArticlesArchivePath = "savedArticles"
  static let SavedSourcesArchiveURL = "savedSources"
  
  func saveArticle(_ article: Article) async throws {
    
    var savedArticles: [Article]?
    if var loadedArticles = try await loadSavedArticles() {
      loadedArticles.append(article)
      savedArticles = loadedArticles
    } else {
      savedArticles = [article]
    }
    
    if let savedArticles {
      do {
        try await saveArticles(articles: savedArticles)
      } catch {
        debugPrint("cannot save article \(error)")
      }
    }
  }
  
  func loadSavedArticles() async throws -> [Article]? {
    guard let articleURL = makeURL(forFileNamed: StorageActor.SavedArticlesArchivePath) else {
      throw StorageError.invalidDirectory
    }
    
    guard let savedArticles = try? Data(contentsOf: articleURL) else {
      return nil
    }
    
    let decoder = JSONDecoder()
    let decodedeArticles = try decoder.decode([Article].self, from: savedArticles)
    return decodedeArticles
  }
  
  func saveSource(_ articleSource: ArticleSource) async throws {
    guard let sourcesURL = makeURL(forFileNamed: StorageActor.SavedSourcesArchiveURL) else {
      throw StorageError.invalidDirectory
    }
    
    var savedSources: [ArticleSource]?
    if var loadedSources = try await loadSavedSources() {
      loadedSources.append(articleSource)
      savedSources = loadedSources
    } else {
      savedSources = [articleSource]
    }
    
    let encoder = JSONEncoder()
    
    if let encodedSources = try? encoder.encode(savedSources) {
      do {
        try encodedSources.write(to: sourcesURL)
      } catch {
        debugPrint(error)
        throw StorageError.writtingFailed
      }
    }
  }
  
  func loadSavedSources() async throws -> [ArticleSource]? {
    guard let sourcesURL = makeURL(forFileNamed: StorageActor.SavedSourcesArchiveURL) else {
      throw StorageError.invalidDirectory
    }
    
    guard let savedSources = try? Data(contentsOf: sourcesURL) else {
      return nil
    }
    let decoder = JSONDecoder()
    let decodedSources = try decoder.decode([ArticleSource].self, from: savedSources)
    return decodedSources
  }
  
  func saveArticles(articles: [Article]) async throws {
    guard let articleURL = makeURL(forFileNamed: StorageActor.SavedArticlesArchivePath) else {
      throw StorageError.invalidDirectory
    }
    
    let encoder = JSONEncoder()
    
    if let encodedArticles = try? encoder.encode(articles) {
      do {
        try encodedArticles.write(to: articleURL)
      } catch {
        debugPrint(error)
        throw StorageError.writtingFailed
      }
    }
  }
  
  private func makeURL(forFileNamed fileName: String) -> URL? {
    guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return nil
    }
    return url.appendingPathComponent(fileName)
  }
}
