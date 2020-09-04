//
//  Category.swift
//  CocktailDB
//
//  Created by debavlad on 04.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import Foundation

struct Category: Decodable {
  let name: String
  var drinks: [Drink]?

  enum CodingKeys: String, CodingKey {
    case name = "strCategory"
    case drinks
  }
}
