//
//  SavedArticlesiewController.swift
//  NewsHeadlines
//
//  Created by Micah Napier on 7/3/2024.
//

import UIKit
import RxSwift
import RxCocoa

class SavedArticlesViewController: UIViewController {
  private let tableView = UITableView()
  private let cellIdentifier = "cellId"
  private var disposeBag = DisposeBag()
  let viewModel = SavedArticleViewModel(storageHandler: StorageActor())

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    title = "Saved Articles"
    
    do {
      try configureTableView()
    } catch {
      debugPrint("could not configure table view\(error)")
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    loadSavedArticles()
  }
  
  func configureTableView() throws {
    tableView.register(ArticleCell.self, forCellReuseIdentifier: cellIdentifier)
    
    tableView.rx.setDelegate(self).disposed(by: disposeBag)
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    viewModel.articles.bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: ArticleCell.self)) { (_,item,cell) in
      cell.article = item
    }.disposed(by: disposeBag)
    
    tableView.rx.itemDeleted
                .subscribe(onNext: {  [weak self] indexPath in
                    guard let self = self else { return }
                  self.remove(indexPath: indexPath)
                }).disposed(by: disposeBag)
    
    tableView.rx.modelSelected(Article.self).subscribe(onNext: { [weak self] article in
      //TODO: coordinator pattern here
      let articleDetailVC = ArticleDetailViewController(article: article)
      self?.navigationController?.pushViewController(articleDetailVC, animated: true)
    }).disposed(by: disposeBag)
  }
  
  func remove(indexPath: IndexPath) {
    Task {
      do {
        try await self.viewModel.removeArticle(at: indexPath)
      } catch {
        debugPrint("could not configure table view\(error)")
      }
    }
  }
  
  func loadSavedArticles() {
    Task {
      try await viewModel.loadSavedArticles()
    }
  }
}

extension SavedArticlesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
}
