//
//  FilterCell.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
  let textLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textColor = .systemGray
    return label
  }()
  private let checkImageView: UIImageView = {
    let image = UIImage(
      systemName: "checkmark",
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular))
    let imageView = UIImageView(image: image)
    imageView.tintColor = .label
    imageView.isHidden = true
    return imageView
  }()
  override var isSelected: Bool {
    didSet {
      checkImageView.isHidden = !isSelected
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }

  func setupSubviews() {
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

  required init?(coder: NSCoder) {
    fatalError()
  }
}
