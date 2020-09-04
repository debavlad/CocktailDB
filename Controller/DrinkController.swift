//
//  ViewController.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

let cache = NSCache<NSString, UIImage>()

class DrinkController: UIViewController {
  let navigationBar = CustomNavigationBar()
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(DrinkCell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.register(CategoryHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    collectionView.backgroundColor = .systemBackground
    return collectionView
  }()
  var categories: [Category] = []
  var drinks: [Int: [Drink]] = [:]

  override func viewDidLoad() {
    super.viewDidLoad()
    cache.countLimit = 200
    view.backgroundColor = .systemBackground
    setupNavigationBar()
    setupCollectionView()
    view.bringSubviewToFront(navigationBar)
    requestInitialData()
  }

  func setupNavigationBar() {
    navigationBar.backButton.isHidden = true
    view.addSubview(navigationBar)
    navigationBar.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      navigationBar.heightAnchor.constraint(equalToConstant: 70)
    ])

    let filterBarButton = BarButton(
      image: UIImage(named: "filter")!,
      target: self,
      action: #selector(presentFilterController(sender:)))
    navigationBar.rightBarButton = filterBarButton
  }

  func setupCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  func updateData() {
    let category = categories[0]
    APIManager.shared.fetchDrinks(of: category) { (drinks) in
      self.drinks[0] = drinks
      self.collectionView.reloadData()
    }
  }

  func requestInitialData() {
    APIManager.shared.fetchCategories { (categories) in
      self.categories = categories
      let category = categories[0]

      APIManager.shared.fetchDrinks(of: category) { (drinks) in
        self.drinks[0] = drinks
        self.collectionView.reloadData()
      }
    }
  }
}

@objc extension DrinkController {
  func presentFilterController(sender: BarButton) {
    let filterController = FilterController()
    filterController.delegate = self
    filterController.modalPresentationStyle = .fullScreen
    present(filterController, animated: true)
  }
}

extension DrinkController: FiltersApplying {
  func filterDrinkCategories(at indexes: [Int]) {
    categories.removeAll()
    drinks.removeAll()
    for i in indexes.sorted() {
      categories.append(APIManager.shared.allCategories[i])
    }
    updateData()
  }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension DrinkController: UICollectionViewDataSource, UICollectionViewDelegate {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return categories.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return drinks[section]?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DrinkCell
    if let drink = drinks[indexPath.section]?[indexPath.item] {
      cell.configure(with: drink)
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! CategoryHeader
    header.titleLabel.text = categories[indexPath.section].name
    return header
  }

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let lastCategoryId = drinks.count - 1
    guard indexPath.section == lastCategoryId else { return }
    let categoryId = lastCategoryId + 1
    guard categories.count > categoryId else { return }
    if indexPath.item == drinks[indexPath.section]!.count - 1 {
      APIManager.shared.fetchDrinks(of: categories[lastCategoryId + 1]) { (drinks) in
        self.drinks[indexPath.section + 1] = drinks
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }
    }
//    if indexPath.item == APIManager.shared.categories[indexPath.section].drinks.count - 1 {
//      APIManager.shared.fetchDrinks(withCategoryId: lastCategoryId) {
//        DispatchQueue.main.async {
//          self.collectionView.reloadData()
//        }
//      }
//    }
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

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    if let _ = drinks[section] {
      return CGSize(width: 0, height: 60)
    } else {
      return .zero
    }
  }
}
