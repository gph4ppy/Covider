//
//  SearchBarModifier.swift
//  Covider
//
//  Created by Jakub Dąbrowski on 27/08/2021.
//

import SwiftUI

struct SearchBarModifier: ViewModifier {
    let searchBar: SearchBar
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ViewControllerResolver { viewController in
                    viewController.navigationItem.searchController = self.searchBar.searchController
                }
                .frame(width: 0, height: 0)
            )
    }
}

extension View {
    func add(_ searchBar: SearchBar) -> some View {
        return self.modifier(SearchBarModifier(searchBar: searchBar))
    }
}
