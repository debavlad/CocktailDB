//
//  DrinkCell.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

final class DrinkCell: UICollectionViewCell {
  let imageView = UIImageView()
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textColor = .gray
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }

  private func setupSubviews() {
    imageView.backgroundColor = .white
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
      imageView.widthAnchor.constraint(equalTo: heightAnchor),
      imageView.heightAnchor.constraint(equalTo: heightAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
}
