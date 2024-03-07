//
//  URLConstructorTests.swift
//  NewsHeadlinesTests
//
//  Created by Micah Napier on 10/3/2024.
//

import XCTest
@testable import NewsHeadlines

final class URLConstructorTests: XCTestCase {

  func testURLConstructorWithSources() {
    let urlConstructor = URLConstructor()
    let testSources = ["test1", "test2"]
    let expectedURL = "https://newsapi.org/v2/top-headlines?sources=test1,test2&apiKey=5f149efaa4da467a911497ced0a9c47f"
    XCTAssertEqual(urlConstructor.urlForArticle(sources: testSources)?.absoluteString, expectedURL)
  }
  
  func testURLConstructorWithNoSources() {
    let urlConstructor = URLConstructor()
    let testSources = [String]()
    let expectedURL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=5f149efaa4da467a911497ced0a9c47f"
    XCTAssertEqual(urlConstructor.urlForArticle(sources: testSources)?.absoluteString, expectedURL)
  }
  
  func testURLConstructorInSourceLanguage() {
    let urlConstructor = URLConstructor()
    let url = urlConstructor.urlForSources()
    
    XCTAssertTrue(try XCTUnwrap(url?.absoluteString.contains("language=en")))
  }

}
