//
//  FilterController.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

protocol FiltersApplying {
  func filterDrinkCategories(at indexes: [Int])
}

class FilterController: UIViewController {
  var categories: [Category] = []
  let navigationBar = CustomNavigationBar()
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset.bottom = 100
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(FilterCell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.backgroundColor = .systemBackground
    return collectionView
  }()
  let applyButton: UIButton = {
    let button = UIButton()
    button.setTitle("APPLY", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    button.setTitleColor(.systemBackground, for: .normal)
    button.backgroundColor = .label
    return button
  }()
  var delegate: FiltersApplying?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    transitioningDelegate = self
    setupNavigationBar()
    setupCollectionView()
    view.bringSubviewToFront(navigationBar)
    setupButton()
  }

  @objc private func backToDrinks() {
    dismiss(animated: true)
  }

  func setupNavigationBar() {
    navigationBar.backButton.addTarget(self, action: #selector(backToDrinks), for: .touchUpInside)
    view.addSubview(navigationBar)
    navigationBar.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      navigationBar.heightAnchor.constraint(equalToConstant: 70)
    ])
  }

  func setupCollectionView() {
    collectionView.allowsMultipleSelection = true
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

  func setupButton() {
    view.addSubview(applyButton)
    applyButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
    applyButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      applyButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -54),
      applyButton.heightAnchor.constraint(equalToConstant: 53),
      applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -27)
    ])
  }

  @objc func applyFilters() {
    guard let indexPaths = collectionView.indexPathsForSelectedItems else {
      return
    }
    let indexes = indexPaths.map {
      $0.item
    }
    delegate?.filterDrinkCategories(at: indexes)
    backToDrinks()
  }
}

//MARK: - UIViewControllerTransitioningDelegate
extension FilterController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return AnimationController(duration: 0.48, type: .present)
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return AnimationController(duration: 0.48, type: .dismiss)
  }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FilterController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categories.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FilterCell
    cell.textLabel.text = categories[indexPath.item].name
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
