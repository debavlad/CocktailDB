//
//  FilterController.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

final class FilterController: UIViewController {
  var categories: [Category] = []
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset.bottom = 100
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(FilterCell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.backgroundColor = .white
    return collectionView
  }()
  let applyButton: UIButton = {
    let button = UIButton()
    button.setTitle("Apply", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .black
    button.layer.cornerRadius = 12
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemYellow
    setupCollectionView()
    setupButton()

    fetchCategories { (retrieved) in
      self.collectionView.reloadData()
    }
  }

  func setupCollectionView() {
    collectionView.allowsMultipleSelection = true
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

  func setupButton() {
    view.addSubview(applyButton)
    applyButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      applyButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -54),
      applyButton.heightAnchor.constraint(equalToConstant: 53),
      applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -27)
    ])
  }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FilterController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categories.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FilterCell
    cell.titleLabel.text = categories[indexPath.item].name
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FilterController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 80)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

// MARK: - Remove later
extension FilterController {
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
      DispatchQueue.main.async { completion(true) }
    }
  }
}
