//
//  APIManager.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

final class API {
  static let shared = API()
  var categories: [Category] = []
  private var filters: [String] = []

  var filteredCategories: [Category] {
    var result: [Category] = []
    for category in categories {
      guard !filters.contains(category.name) else {
        continue
      }
      result.append(category)
    }
    return result
  }

  private let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/"
  private let categoryString = "list.php?c=list"
  private let drinkString = "filter.php?c="

  func setFilters(_ filters: [String]?) {
    guard let filters = filters else {
      return
    }
    self.filters = filters
  }

  func hasFilter(_ category: Category) -> Bool {
    return filters.contains(category.name)
  }
}

// MARK: - Main API functionality
extension API {
  func getCategoriesList(completion: @escaping ([Category]) -> Void) {
    let urlString = baseURL + categoryString
    guard let url = URL(string: urlString) else {
      return
    }
    URLSession.shared.dataTask(with: url) { (data, _, error) in
      guard let data = data, error == nil else { return }
      do {
        let decoder = JSONDecoder()
        let json = try decoder.decode(CategoriesRoot.self, from: data)
        DispatchQueue.main.async {
          self.categories = json.categories
          completion(self.filteredCategories)
        }
      } catch {
        print(error.localizedDescription)
      }
    }.resume()
  }

  func fetchCategory(_ category: Category, completion: @escaping ([Drink]) -> Void) {
    let formattedCategory = category.name.replacingOccurrences(of: " ", with: "_")
    let urlString = baseURL + drinkString + formattedCategory
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
