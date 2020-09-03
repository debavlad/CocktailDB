//
//  ViewController.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var categories: [Category] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    fetchCategories { (received) in
      if received {
        self.fetchDrinks(at: 0)
      }
    }
  }
}

extension ViewController {
  func fetchCategories(completion: @escaping (_ success: Bool) -> Void) {
    APIManager.shared.requestCategories { (dict) in
      guard let array = dict?["drinks"] as? [[String: String]] else {
        completion(false)
        return
      }

      for json in array {
        let category = Category(json["strCategory"]!)
        self.categories.append(category)
      }
      completion(true)
    }
  }

  func fetchDrinks(at id: Int) {
    let categoryName = categories[id].name
    APIManager.shared.requestDrinks(of: categoryName) { (dict) in
      guard let array = dict?["drinks"] as? [[String: String]] else {
        return
      }

      for json in array {
        let drink = Drink(
          name: json["strDrink"]!,
          thumb: json["strDrinkThumb"]!)
        self.categories[id].drinks.append(drink)
      }
    }
  }
}
