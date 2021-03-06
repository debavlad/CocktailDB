//
//  CustomNavigationBar.swift
//  CocktailDB
//
//  Created by debavlad on 04.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

final class CustomNavigationBar: UIView {

  static var notchInset: CGFloat = 0

  let backButton: BarButton = {
    let image = UIImage(named: "back")?.withTintColor(.label)
    let button = BarButton(image: image!)
    return button
  }()
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .semibold)
    label.textColor = .label
    return label
  }()
  var rightBarButton: BarButton? {
    didSet {
      layoutRightBarButton()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupAppearance()
    setupSubviews()
  }

  private func setupAppearance() {
    backgroundColor = .systemBackground
    layer.shadowColor = UIColor.label.cgColor
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
    guard let rightBarButton = rightBarButton else {
      return
    }
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
