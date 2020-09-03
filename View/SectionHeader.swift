//
//  SectionHeader.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
  let textLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .gray
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLabel()
  }

  func setupLabel() {
    addSubview(textLabel)
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
}