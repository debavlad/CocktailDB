//
//  CustomNavigationBar.swift
//  CocktailDB
//
//  Created by debavlad on 04.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

class CustomNavigationBar: UIView {
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .semibold)
    label.text = "Drinks"
    label.textColor = .black
    return label
  }()
  let backButton = BarButton(image: UIImage(named: "back")!)
  var rightBarButton: BarButton? {
    didSet {
      layoutRightBarButton()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    setupAppearance()
    setupSubviews()
  }

  private func setupAppearance() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset.height = 4
    layer.shadowRadius = 4
    layer.shadowOpacity = 0.25
  }

  private func setupSubviews() {
    let stackView = UIStackView(arrangedSubviews: [backButton,titleLabel])
    stackView.axis = .horizontal
    stackView.spacing = 40
    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -21)
    ])
  }

  private func layoutRightBarButton() {
    guard let rightBarButton = rightBarButton else { return }
    addSubview(rightBarButton)
    rightBarButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      rightBarButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21),
      rightBarButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
}
