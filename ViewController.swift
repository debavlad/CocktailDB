//
//  ViewController.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

class Category {
  let name: String
  var drinks: [Drink] = []

  init(_ name: String) {
    self.name = name
  }
}

struct Drink {
  var name: String
  var thumb: String
}

class ViewController: UIViewController {
  var categories: [Category] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    fetchCategories { (success) in
      if success {
        self.fetchDrinks(with: 0)
      }
    }
  }

  func fetchDrinks(with categoryId: Int) {
    let category = categories[categoryId].name
    requestDrinks(with: category) { (dict, error) in
      guard let array = dict?["drinks"] as? [[String: String]] else {
        return
      }
      for x in array {
        let drink = Drink(
          name: x["strDrink"]!,
          thumb: x["strDrinkThumb"]!)
        self.categories[categoryId].drinks.append(drink)
      }
    }
  }

  func fetchCategories(completion: @escaping (_ success: Bool) -> Void) {
    requestCategories { (dict, error) in
      guard let array = dict?["drinks"] as? [[String: String]] else {
        completion(false)
        return
      }
      for x in array {
        let category = Category(x["strCategory"]!)
        self.categories.append(category)
      }
      completion(true)
    }
  }
}

extension ViewController {
  private func requestDrinks(with category: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
    let formattedCategory = category.replacingOccurrences(of: " ", with: "_")
    let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(formattedCategory)")!
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data else { return }
      do {
        if let array = try JSONSerialization.jsonObject(
          with: data, options: .allowFragments) as? [String: Any] {
          completion(array, nil)
        }
      } catch {
        print(error)
      }
    }.resume()
  }

  private func requestCategories(completion: @escaping ([String: Any]?, Error?) -> Void) {
    let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list")!
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data else { return }
      do {
        if let array = try JSONSerialization.jsonObject(
          with: data, options: .allowFragments) as? [String: Any] {
          completion(array, nil)
        }
      } catch {
        print(error)
      }
    }.resume()
  }
}

extension ViewController: URLSessionDelegate {

}
