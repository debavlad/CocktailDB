//
//  CustomHeader.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

final class CustomHeaderView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .systemRed
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
}
