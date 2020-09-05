//
//  FilterController.swift
//  CocktailDB
//
//  Created by debavlad on 03.09.2020.
//  Copyright © 2020 debavlad. All rights reserved.
//

import UIKit

protocol DataReloading {
  func reloadData()
}

final class FilterController: UIViewController {
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset.bottom = 100
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(FilterCell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.backgroundColor = .systemBackground
    return collectionView
  }()

  let navigationBar = CustomNavigationBar()

  let applyButton: UIButton = {
    let button = UIButton()
    button.setTitle("APPLY", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    button.setTitleColor(.systemBackground, for: .normal)
    button.backgroundColor = .label
    return button
  }()

  var categories: [Category] = []
  var delegate: DataReloading?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    transitioningDelegate = self

    categories = API.shared.categories
    setupNavigationBar()
    setupCollectionView()
    setupButton()
  }

  override func viewWillAppear(_ animated: Bool) {
    for i in 0..<categories.count {
      guard API.shared.hasFilter(categories[i]) else {
        continue
      }
      collectionView.selectItem(
        at: IndexPath(item: i, section: 0),
        animated: false,
        scrollPosition: .top)
    }
  }

  func setupNavigationBar() {
    navigationBar.titleLabel.text = "Filters"
    navigationBar.backButton.addTarget(
      self,
      action: #selector(backToDrinks),
      for: .touchUpInside)

    view.addSubview(navigationBar)
    navigationBar.translatesAutoresizingMaskIntoConstraints = false
    let height = 70 + CustomNavigationBar.notchInset
    NSLayoutConstraint.activate([
      navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
      navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      navigationBar.heightAnchor.constraint(equalToConstant: height)
    ])
  }

  func setupCollectionView() {
    collectionView.allowsMultipleSelection = true
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
}

// MARK: - Target actions
@objc extension FilterController {
  @objc func applyFilters() {
    let filters = collectionView.indexPathsForSelectedItems?.map {
      categories[$0.item].name
    }
    API.shared.setFilters(filters)
    delegate?.reloadData()
    backToDrinks()
  }

  @objc private func backToDrinks() {
    dismiss(animated: true)
  }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FilterController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categories.count
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    updateApplyButton()
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    updateApplyButton()
  }

  private func updateApplyButton() {
    guard let selectedItems = collectionView.indexPathsForSelectedItems else {
      return
    }

    if selectedItems.count == categories.count {
      applyButton.backgroundColor = .secondaryLabel
      applyButton.isEnabled = false
    } else {
      applyButton.backgroundColor = .label
      applyButton.isEnabled = true
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FilterCell
    cell.category = categories[indexPath.item]
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

// MARK: - UIViewControllerTransitioningDelegate
extension FilterController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return AnimationController(duration: 0.48, type: .present)
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return AnimationController(duration: 0.48, type: .dismiss)
  }
}
