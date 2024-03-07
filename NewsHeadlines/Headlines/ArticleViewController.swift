//
//  ArticleViewController.swift
//  NewsHeadlines
//
//  Created by Micah Napier on 7/3/2024.
//

import UIKit
import RxSwift
import RxCocoa

class ArticleViewController: UIViewController {
  private let tableView = UITableView()
  private let viewModel = ArticleViewModel(articleFetcher: NetworkActor(), storageHandler: StorageActor())
  private var disposeBag = DisposeBag()
  private let cellIdentifier = "cellId"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Headlines"
    view.backgroundColor = .white
    configureTableView()
    fetchArticles()
  }
  
  func fetchArticles() {
    Task {
      try await viewModel.fetchArticles()
      tableView.reloadData()
    }
  }
  
  func configureTableView() {
    tableView.register(ArticleCell.self, forCellReuseIdentifier: cellIdentifier)
    
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    
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
    
    tableView.rx.modelSelected(Article.self).subscribe(onNext: { [weak self] article in
      //TODO: coordinator pattern here
      let articleDetailVC = ArticleDetailViewController(article: article)
      self?.navigationController?.pushViewController(articleDetailVC, animated: true)
    }).disposed(by: disposeBag)
  }
  
  @objc func pullToRefresh() {
    fetchArticles()
    self.tableView.refreshControl?.endRefreshing()
  }
}

extension ArticleViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
