//
//  SavedArticleViewModel.swift
//  NewsHeadlines
//
//  Created by Micah Napier on 10/3/2024.
//

import Foundation
import RxSwift
import RxCocoa

actor SavedArticleViewModel {
  let articles = BehaviorSubject<[Article]>(value: [Article]())
  let storageHandler: StorageHandler
  
  init(storageHandler: StorageHandler) {
    self.storageHandler = storageHandler
  }
  
  func loadSavedArticles() async throws {
    guard let fetchedArticles = try await storageHandler.loadSavedArticles() else {
      throw ArticleError.notFound
    }
    articles.onNext(fetchedArticles)
  }
  
  func removeArticle(at indexPath: IndexPath) async throws {
    var articleValues = try self.articles.value()
    articleValues.remove(at: indexPath.row)
    try await storageHandler.saveArticles(articles: articleValues)
    articles.onNext(articleValues)
  }
}
