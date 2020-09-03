//
//  Category.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import Foundation

final class Category {
  let name: String
  var drinks: [Drink] = []

  init(_ name: String) {
    self.name = name
  }
}
