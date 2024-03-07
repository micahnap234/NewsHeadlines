//
//  SourcesViewController.swift
//  NewsHeadlines
//
//  Created by Micah Napier on 7/3/2024.
//

import UIKit
import RxSwift
import RxCocoa

class SourcesViewController: UIViewController, UITableViewDelegate {
  private let tableView = UITableView()
  private let viewModel = SourcesViewModel(articleFetcher: NetworkActor(), storageHandler: StorageActor())
  private let disposeBag = DisposeBag()
  private let cellIdentifier = "cellId"

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    title = "Sources"
    
    configureTableView()
    fetchSources()
  }
  
  func fetchSources() {
    Task {
      try await viewModel.fetchSources()
    }
  }
  
  func configureTableView() {
    tableView.allowsMultipleSelection = true
    tableView.register(SourceCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.rx.setDelegate(self).disposed(by: disposeBag)
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    viewModel.sources.bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: SourceCell.self)) { (row,item,cell) in
      cell.source = item
    }.disposed(by: disposeBag)
    
    tableView.rx.modelSelected(ArticleSource.self).subscribe(onNext: { [weak self] source in
      self?.viewModel.saveSource(articleSource: source)
    }).disposed(by: disposeBag)
  }
}

