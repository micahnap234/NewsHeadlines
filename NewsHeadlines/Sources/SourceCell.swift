//
//  SourceCell.swift
//  NewsHeadlines
//
//  Created by Micah Napier on 9/3/2024.
//

import UIKit

class SourceCell: UITableViewCell {
  
  private let sourceTitleLabel: UILabel = {
    let lbl = UILabel()
    lbl.textColor = .black
    lbl.font = UIFont.boldSystemFont(ofSize: 16)
    lbl.textAlignment = .left
    lbl.numberOfLines = 0
    return lbl
  }()
  
  private let sourceDescriptionLabel: UILabel = {
    let lbl = UILabel()
    lbl.textColor = .lightGray
    lbl.font = UIFont.boldSystemFont(ofSize: 14)
    lbl.textAlignment = .left
    return lbl
  }()
  
  var source: ArticleSource? {
    didSet {
      sourceTitleLabel.text = source?.name
      sourceDescriptionLabel.text = source?.description
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    let vStack = UIStackView(arrangedSubviews: [sourceTitleLabel, sourceDescriptionLabel])
    vStack.spacing = 3
    vStack.axis = .vertical
    vStack.alignment = .leading
    vStack.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(vStack)
    
    NSLayoutConstraint.activate([
      vStack.topAnchor.constraint(equalTo: topAnchor, constant: 5.0),
      vStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0),
      vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.0),
      vStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
