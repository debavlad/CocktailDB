//
//  APIManager.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import Foundation

final class APIManager {
  static let shared = APIManager()
  
  private let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/"
  private let categoriesURL = "list.php?c=list"
  private let drinksURL = "filter.php?c="

  func fetchCategories(completion: @escaping ([Category]) -> Void) {
    let urlString = baseURL + categoriesURL
    guard let url = URL(string: urlString) else { return }
    URLSession.shared.dataTask(with: url) { (data, _, error) in
      guard let data = data, error == nil else { return }
      do {
        let decoder = JSONDecoder()
        let json = try decoder.decode(CategoriesRoot.self, from: data)
        DispatchQueue.main.async {
          completion(json.categories)
        }
      } catch {
        print(error.localizedDescription)
      }
    }.resume()
  }

  func fetchDrinks(of category: Category, completion: @escaping ([Drink]) -> Void) {
    let formattedCategory = category.name.replacingOccurrences(of: " ", with: "_")
    let urlString = baseURL + drinksURL + formattedCategory
    guard let url = URL(string: urlString) else { return }
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
