//
//  ArticleCell.swift
//  NewsHeadlines
//
//  Created by Micah Napier on 8/3/2024.
//

import UIKit
import Kingfisher

class ArticleCell: UITableViewCell {
  private let articleTitleLabel: UILabel = {
    let lbl = UILabel()
    lbl.textColor = .black
    lbl.font = UIFont.boldSystemFont(ofSize: 16)
    lbl.textAlignment = .left
    lbl.numberOfLines = 0
    return lbl
  }()
  
  private let articleAuthorLabel: UILabel = {
    let lbl = UILabel()
    lbl.textColor = .lightGray
    lbl.font = UIFont.boldSystemFont(ofSize: 14)
    lbl.textAlignment = .left
    return lbl
  }()
  
  private let articleDescriptionLabel : UILabel = {
    let lbl = UILabel()
    lbl.textColor = .black
    lbl.font = UIFont.systemFont(ofSize: 14)
    lbl.textAlignment = .left
    lbl.numberOfLines = 0
    return lbl
  }()
  
  private let articleImageView : UIImageView = {
    let imgView = UIImageView(image: UIImage(named: "defaultImage"))
    imgView.contentMode = .scaleAspectFit
    imgView.clipsToBounds = true
    return imgView
  }()
  
  var article: Article? {
    didSet {
      articleAuthorLabel.text = article?.author
      articleTitleLabel.text = article?.title
      articleDescriptionLabel.text = article?.description
      articleImageView.kf.setImage(with: article?.urlToImage)
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    let innerVStack = UIStackView(arrangedSubviews: [articleTitleLabel, articleDescriptionLabel])
    innerVStack.spacing = 3
    innerVStack.axis = .vertical
    innerVStack.alignment = .leading
    innerVStack.translatesAutoresizingMaskIntoConstraints = false
    
    let innerHStack = UIStackView(arrangedSubviews: [articleImageView, innerVStack])
    innerHStack.distribution = .equalCentering
    innerHStack.alignment = .center
    innerHStack.axis = .horizontal
    innerHStack.spacing = 5
    innerHStack.translatesAutoresizingMaskIntoConstraints = false
    
    let stackView = UIStackView(arrangedSubviews: [articleAuthorLabel, innerHStack])
    stackView.axis = .vertical
    stackView.spacing = 5
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)
    
    let imageHeightConstraint = articleImageView.heightAnchor.constraint(equalToConstant: 80)
    imageHeightConstraint.priority = .defaultHigh
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5.0),
      stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.0),
      stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0),
      imageHeightConstraint,
      articleImageView.widthAnchor.constraint(equalToConstant: 80)
    ])
    
    layoutIfNeeded()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
