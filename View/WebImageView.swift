//
//  CustomImageView.swift
//  CocktailDB
//
//  Created by debavlad on 04.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

class WebImageView: UIImageView {
  private var imageUrlString: String?

  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    contentMode = .scaleAspectFill
  }

  func loadFromUrlString(_ urlString: String) {
    imageUrlString = urlString
    let url = URL(string: urlString)
    image = nil

    if let imageFromCache = cache.object(forKey: urlString as NSString) {
      image = imageFromCache
      return
    }
    URLSession.shared.dataTask(with: url!) { (data, _, error) in
      guard let data = data, error == nil else { return }
      DispatchQueue.main.async {
        let imageToCache = UIImage(data: data)
        if self.imageUrlString == urlString {
          self.image = imageToCache
        }
        cache.setObject(imageToCache!, forKey: urlString as NSString)
      }
    }.resume()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
}
