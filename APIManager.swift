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

  typealias URLRequestHandler = ([String: Any]?) -> Void

  private func requestData(at url: URL, completion: @escaping URLRequestHandler) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let data = data, error == nil {
        do {
          if let array = try JSONSerialization.jsonObject(
            with: data, options: .allowFragments) as? [String: Any] {
            completion(array)
          }
        } catch {
          print(error)
        }
      }
    }.resume()
  }

  func requestDrinks(of category: String, completion: @escaping URLRequestHandler) {
    let formattedCategory = category.replacingOccurrences(of: " ", with: "_")
    let url = URL(
      string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(formattedCategory)")!
    requestData(at: url) { (data) in
      completion(data)
    }
  }

  func requestCategories(completion: @escaping URLRequestHandler) {
    let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list")!
    requestData(at: url) { (data) in
      completion(data)
    }
  }
}
