//
//  WelcomeScreenModel.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct WelcomeScreenModel: Identifiable, Hashable {
    static func == (lhs: WelcomeScreenModel, rhs: WelcomeScreenModel) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(description)
    }
    
    let id = UUID().uuidString
    let welcomeView: AnyView
    let title: String
    let description: String
}
