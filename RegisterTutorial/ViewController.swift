//
//  ViewController.swift
//  RegisterTutorial
//
//  Created by Rennan Rebouças on 06/09/19.
//  Copyright © 2019 Rennan Rebouças. All rights reserved.
//

import UIKit

struct Character {
    let image: UIImage
    let name: String
    
    static let mockedChars: [Character] = [
        Character(image: UIImage(named: "epona")! , name: "Epona"),
        Character(image: UIImage(named: "zelda")!, name: "Zelda"),
        Character(image: UIImage(named: "link")!, name: "Link")
    ]
}

class ViewController: RegisterCollectionViewController {

    // MARK: Properties
    let searchController = UISearchController(searchResultsController: nil)
    var model = Character.mockedChars
    
    // MARK: Inicialization
    override func viewDidLoad() {
        super.viewDidLoad()
        charCollectionView.delegate = self
        charCollectionView.dataSource = self
        
        setupCollectionViewConstraints()
        setupSearchController()
    }
    
    private func setupSearchController() {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupNavigation() {
        self.title = "Table View"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .white
    }
    
    // MARK: - Private instance methods
      
    func searchBarIsEmpty() -> Bool {
      // Returns true if the text is empty or nil
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
      return searchController.isActive && !searchBarIsEmpty()
    }
      
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        if searchText.isEmpty {
            model = Character.mockedChars
        } else {
            model = model.filter({$0.name.lowercased().contains(searchText.lowercased())})
        }
        
        charCollectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = charCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CharactersCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(char: model[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10))
        
        return CGSize(width: itemSize, height: itemSize)
    }
    
}

//   MARK: Extensions
extension ViewController {
    
    func setupCollectionViewConstraints() {
        self.view.addSubview(self.charCollectionView)
    
        NSLayoutConstraint.activate([
            charCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            charCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            charCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            charCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

extension ViewController: UISearchResultsUpdating {
  // MARK: - UISearchResultsUpdating Delegate
  func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
  }
}
