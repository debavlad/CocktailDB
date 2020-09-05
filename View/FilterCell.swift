//
//  FilterCell.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

final class FilterCell: UICollectionViewCell {

  var category: Category? {
    didSet {
      if let category = category {
        textLabel.text = category.name
        setupSubviews()
      }
    }
  }

  override var isSelected: Bool {
    didSet {
      checkImageView.isHidden = isSelected
    }
  }

  private let textLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textColor = .systemGray
    return label
  }()

  private let checkImageView: UIImageView = {
    let image = UIImage(
      systemName: "checkmark",
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
    let imageView = UIImageView(image: image)
    imageView.tintColor = .label
    return imageView
  }()

  private func setupSubviews() {
    addSubview(textLabel)
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35)
    ])

    addSubview(checkImageView)
    checkImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      checkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      checkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35)
    ])
  }

}
