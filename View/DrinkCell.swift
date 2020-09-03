//
//  DrinkCell.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

final class DrinkCell: UICollectionViewCell {
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 8
    imageView.layer.masksToBounds = true
    return imageView
  }()
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textColor = .gray
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 3
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }

  private func setupSubviews() {
    let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.spacing = 21
    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
      imageView.widthAnchor.constraint(equalTo: heightAnchor),
      imageView.heightAnchor.constraint(equalTo: heightAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
}
