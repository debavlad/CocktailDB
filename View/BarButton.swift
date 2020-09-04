//
//  BarButton.swift
//  CocktailDB
//
//  Created by debavlad on 04.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

class BarButton: UIButton {
  init(image: UIImage, target: Any? = nil, action: Selector? = nil) {
    super.init(frame: .zero)
    setImage(image, for: .normal)
    if let target = target, let action = action {
      addTarget(target, action: action, for: .touchUpInside)
    }
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
}
