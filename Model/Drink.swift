//
//  Drink.swift
//  CocktailDB
//
//  Created by debavlad on 04.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import Foundation

struct Drink: Decodable {
  let name: String
  let imageURL: String

  enum CodingKeys: String, CodingKey {
    case name = "strDrink"
    case imageURL = "strDrinkThumb"
  }
}
