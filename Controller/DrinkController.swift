//
//  ViewController.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

// TODO: Image cache
final class DrinkController: UIViewController {
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.headerReferenceSize.height = 60
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(DrinkCell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    collectionView.backgroundColor = .systemBackground
    return collectionView
  }()
  var categories: [Category] = []
  var lastCategoryId = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.tintColor = .systemGray2
    title = "Drinks"
    setupCollectionView()
    setupBarButton()

    fetchCategories { (received) in
      guard received else { return }
      self.fetchDrinks(at: self.lastCategoryId) {
        self.collectionView.reloadData()
      }
    }
  }

  @objc func presentFilterController() {
    let filterController = FilterController()
    filterController.categories = categories.map { $0.name }
    navigationController?.pushViewController(filterController, animated: true)
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

  func setupBarButton() {
    let barButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 19, weight: .light)), style: .plain, target: self, action: #selector(presentFilterController))
    barButton.tintColor = .systemGray2
    navigationItem.rightBarButtonItem = barButton
  }
}

// MARK: - Fetching data via APIManager
extension DrinkController {
  func fetchCategories(completion: @escaping (_ success: Bool) -> Void) {
    APIManager.shared.requestCategories { (dict) in
      guard let array = dict?["drinks"] as? [[String: String]] else {
        DispatchQueue.main.async { completion(false) }
        return
      }
      for json in array {
        let category = Category(json["strCategory"]!)
        self.categories.append(category)
      }
      DispatchQueue.main.async {
        completion(true)
      }
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
      DispatchQueue.main.async {
        completion()
      }
    }
  }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension DrinkController: UICollectionViewDataSource, UICollectionViewDelegate {
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

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard indexPath.section == lastCategoryId else { return }
    if indexPath.item == categories[indexPath.section].drinks.count - 1 {
      lastCategoryId += 1
      fetchDrinks(at: lastCategoryId) {
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }
    }
  }

  private func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
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
extension DrinkController: UICollectionViewDelegateFlowLayout {
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
