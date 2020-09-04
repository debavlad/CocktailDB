//
//  SectionHeader.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

final class CategoryHeader: UICollectionReusableView {
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .systemGray
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLabel()
  }

  private func setupLabel() {
    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
}
