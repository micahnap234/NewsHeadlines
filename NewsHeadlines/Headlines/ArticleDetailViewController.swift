//
//  ArticleDetailViewController.swift
//  NewsHeadlines
//
//  Created by Micah Napier on 8/3/2024.
//

import UIKit
import WebKit

struct ArticleDetailViewModel {
  let storageHandler: StorageHandler
  init(storageHandler: StorageHandler) {
    self.storageHandler = storageHandler
  }
  
  func save(article: Article) async {
    do {
      try await storageHandler.saveArticle(article)
    } catch {
      debugPrint("Error saving: \(String(describing: error))")
    }
  }
}

class ArticleDetailViewController: UIViewController {
  let article: Article
  let webView: WKWebView = WKWebView()
  let viewModel = ArticleDetailViewModel(storageHandler: StorageActor())
  
  init(article: Article) {
    self.article = article
    super.init(nibName: nil, bundle: nil)
    
    let rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveArticle))
    navigationItem.rightBarButtonItem = rightBarButtonItem
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureWebView()
  }
  
  func configureWebView() {
    view.addSubview(webView)
    
    webView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      webView.leftAnchor.constraint(equalTo: view.leftAnchor),
      webView.rightAnchor.constraint(equalTo: view.rightAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    loadURL()
  }
  
  func loadURL() {
    if let articleURL = article.url {
      let requestObj = URLRequest(url: articleURL)
      webView.load(requestObj)
    }
  }
  
  @objc func saveArticle() {
    Task {
      await viewModel.save(article: article)
    }
  }
  
}
