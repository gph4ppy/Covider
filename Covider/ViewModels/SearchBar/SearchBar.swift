//
//  SearchBar.swift
//  Covider
//
//  Created by Jakub Dąbrowski on 27/08/2021.
//

import SwiftUI

class SearchBar: NSObject, ObservableObject {
    @Published var text: String = ""
    let searchController = UISearchController(searchResultsController: nil)
    
    override init() {
        super.init()
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
    }
}

extension SearchBar: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        // Publish search bar text changes.
        if let searchBarText = searchController.searchBar.text {
            self.text = searchBarText
        }
    }
}
