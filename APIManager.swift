//
//  APIManager.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

final class APIManager {
  static let shared = APIManager()
  var allCategories: [Category] = []
  var filters: [String] = []

  var deviceNotchInset: CGFloat = 0

  var filteredCategories: [Category] {
    var filteredCategories: [Category] = []
    for category in allCategories {
      guard !filters.contains(category.name) else { continue }
      filteredCategories.append(category)
    }
    return filteredCategories
  }
  
  private let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/"
  private let categoriesURL = "list.php?c=list"
  private let drinksURL = "filter.php?c="

  func getCategoriesList(completion: @escaping ([Category]) -> Void) {
    let urlString = baseURL + categoriesURL
    guard let url = URL(string: urlString) else {
      return
    }

    URLSession.shared.dataTask(with: url) { (data, _, error) in
      guard let data = data, error == nil else { return }
      do {
        let decoder = JSONDecoder()
        let json = try decoder.decode(CategoriesRoot.self, from: data)
        DispatchQueue.main.async {
          self.allCategories = json.categories
          completion(self.filteredCategories)
        }
      } catch {
        print(error.localizedDescription)
      }
    }.resume()
  }

  func fetchCategory(_ category: Category, completion: @escaping ([Drink]) -> Void) {
    let formattedCategory = category.name.replacingOccurrences(of: " ", with: "_")
    let urlString = baseURL + drinksURL + formattedCategory
    guard let url = URL(string: urlString) else {
      return
    }

    URLSession.shared.dataTask(with: url) { (data, _, error) in
      guard let data = data, error == nil else { return }
      do {
        let decoder = JSONDecoder()
        let json = try decoder.decode(DrinksRoot.self, from: data)
        DispatchQueue.main.async {
          completion(json.drinks)
        }
      } catch {
        print(error.localizedDescription)
      }
    }.resume()
  }
}

extension APIManager {
  private struct CategoriesRoot: Decodable {
    let categories: [Category]

    enum CodingKeys: String, CodingKey {
      case categories = "drinks"
    }
  }

  private struct DrinksRoot: Decodable {
    let drinks: [Drink]

    enum CodingKeys: String, CodingKey {
      case drinks
    }
  }
}
