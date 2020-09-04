//
//  ViewController.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

let cache = NSCache<NSString, UIImage>()

final class DrinkController: UIViewController {
  let navigationBar = CustomNavigationBar()
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(DrinkCell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.register(CategoryHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    collectionView.backgroundColor = .systemBackground
    return collectionView
  }()

  let apiManager = APIManager.shared
  var categories: [Category] = []
  var lastLoadedSectionId = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    cache.countLimit = 200
    view.backgroundColor = .systemBackground

    setupNavigationBar()
    setupCollectionView()
    reloadData()
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
    view.insertSubview(collectionView, at: 0)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  @objc func presentFilterController(sender: BarButton) {
    let filterController = FilterController()
    filterController.delegate = self
    filterController.modalPresentationStyle = .fullScreen
    present(filterController, animated: true)
  }
}

// MARK: - DataReloading
extension DrinkController: DataReloading {
  func reloadData() {
    lastLoadedSectionId = 0
    categories.removeAll()
    apiManager.getCategoriesList { (categories) in
      self.categories = categories
      guard categories.count > 0 else {
        return
      }
      self.apiManager.fetchCategory(categories[0]) { (drinks) in
        self.categories[0].drinks = drinks
        self.collectionView.reloadData()
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
    return categories[section].drinks?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DrinkCell
    if let drink = categories[indexPath.section].drinks?[indexPath.item] {
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
    if reachedBottom(with: indexPath) && canFetchMore {
      let nextCategory = categories[lastLoadedSectionId + 1]
      apiManager.fetchCategory(nextCategory) { (drinks) in
        self.categories[self.lastLoadedSectionId + 1].drinks = drinks
        self.lastLoadedSectionId += 1
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }
    }
  }

  func reachedBottom(with indexPath: IndexPath) -> Bool {
    guard let drinks = categories[lastLoadedSectionId].drinks else {
      return false
    }
    return indexPath.section == lastLoadedSectionId &&
      indexPath.item == drinks.count - 1
  }

  var canFetchMore: Bool {
    return categories.count > lastLoadedSectionId + 1
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
    if let _ = categories[section].drinks {
      return CGSize(width: 0, height: 60)
    } else {
      return .zero
    }
  }
}
