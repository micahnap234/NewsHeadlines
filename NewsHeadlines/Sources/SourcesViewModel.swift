//
//  SourcesViewModel.swift
//  NewsHeadlines
//
//  Created by Micah Napier on 8/3/2024.
//

import Foundation
import RxCocoa
import RxSwift

class SourcesViewModel {
  let sources = PublishSubject<[ArticleSource]>()
  let netActor: ArticleFetcher
  let storageHandler: StorageHandler
  
  init(articleFetcher: ArticleFetcher, storageHandler: StorageHandler) {
    self.netActor = articleFetcher
    self.storageHandler = storageHandler
  }
  
  func fetchSources() async throws {
    guard let fetchedSources = try await netActor.getSources() else {
      throw ArticleError.notFound
    }
    sources.onNext(fetchedSources)
    sources.onCompleted()
  }
  
  func saveSource(articleSource: ArticleSource) {
    Task {
      do {
        try await storageHandler.saveSource(articleSource)
      } catch {
        debugPrint("Error saving: \(String(describing: error))")
      }
    }
  }
}
