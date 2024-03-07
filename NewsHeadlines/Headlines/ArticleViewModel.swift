//
//  ArticleViewModel.swift
//  NewsHeadlines
//
//  Created by Micah Napier on 7/3/2024.
//

import Foundation
import RxCocoa
import RxSwift

enum ArticleError: Error {
    case invalidURL
    case notFound
}

struct ArticleViewModel {
  let articles = BehaviorSubject<[Article]>(value: [Article]())
  let netActor: ArticleFetcher
  let storageHandler: StorageHandler
  
  init(articleFetcher: ArticleFetcher, storageHandler: StorageHandler) {
    self.netActor = articleFetcher
    self.storageHandler = storageHandler
  }
  
  func fetchArticles() async throws {
    let savedSources = try await storageHandler.loadSavedSources()
    let sources: [String] = savedSources?.compactMap { $0.id } ?? []
    
    guard let fetchedArticles = try await netActor.getArticles(for: sources) else {
      throw ArticleError.notFound
    }
    
    articles.onNext(fetchedArticles)
  }
}


