//
//  DrinkCell.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

final class DrinkCell: UICollectionViewCell {

  var drink: Drink? {
    didSet {
      if let drink = drink {
        textLabel.text = drink.name
        imageView.loadFromUrlString(drink.imageURL)
        setupSubviews()
      }
    }
  }

  private let imageView = WebImageView()

  private let textLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textColor = .systemGray
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 3
    return label
  }()

  private func setupSubviews() {
    let stackView = UIStackView(arrangedSubviews: [imageView, textLabel])
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.spacing = 21
    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      textLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
      imageView.widthAnchor.constraint(equalTo: heightAnchor),
      imageView.heightAnchor.constraint(equalTo: heightAnchor)
    ])
  }
  
}
