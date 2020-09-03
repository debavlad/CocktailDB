//
//  ViewController.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.headerReferenceSize.height = 60
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(DrinkCell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    collectionView.backgroundColor = .white
    return collectionView
  }()
  var categories: [Category] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupCollectionView()
    fetchCategories { (received) in
      if received {
        self.fetchDrinks(at: 0) {
          DispatchQueue.main.async {
            self.collectionView.reloadData()
          }
        }
      }
    }
  }

  func setupCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: - Fetching data
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

  func fetchDrinks(at id: Int, completion: @escaping () -> Void) {
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
      completion()
    }
  }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return categories.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categories[section].drinks.count
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! SectionHeader
    header.textLabel.text = categories[indexPath.section].name
    return header
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DrinkCell
    let drink = categories[indexPath.section].drinks[indexPath.item]
    cell.titleLabel.text = drink.name
    downloadImage(from: drink.thumb) { (image) in
      cell.imageView.image = image
    }
    return cell
  }

  func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
    let url = URL(string: "\(urlString)/preview")!
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else { return }
      DispatchQueue.main.async {
        completion(UIImage(data: data))
      }
    }.resume()
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 100)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 40
  }
}
