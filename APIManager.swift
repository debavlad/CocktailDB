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
  var categories: [Category] = []

  typealias URLRequestHandler = ([[String: String]]?) -> Void
  typealias CompletionBlock = (() -> Void)?

  private func requestData(at url: URL, completion: @escaping URLRequestHandler) {
    URLSession.shared.dataTask(with: url) { (data, _, error) in
      guard let data = data, error == nil else { return }
      do {
        if let dict = try JSONSerialization.jsonObject(
          with: data, options: .allowFragments) as? [String: Any] {
          completion(dict["drinks"] as? [[String: String]])
        }
      } catch {
        print(error.localizedDescription)
      }
    }.resume()
  }

  func fetchDrinks(withCategoryId id: Int, completion: CompletionBlock = nil) {
    guard categories.count > id else { return }
    let category = categories[id].name.replacingOccurrences(of: " ", with: "_")
    let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(category)")!
    requestData(at: url) { (json) in
      guard let json = json else { return }
      self.categories[id].drinks = json.map {
        Drink(name: $0["strDrink"]!, thumb: $0["strDrinkThumb"]!)
      }
      DispatchQueue.main.async {
        completion?()
      }
    }
  }

  func fetchCategories(completion: CompletionBlock) {
    let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list")!
    requestData(at: url) { (json) in
      guard let json = json else { return }
      self.categories = json.map {
        Category($0["strCategory"]!)
      }
      DispatchQueue.main.async {
        completion?()
      }
    }
  }
}
