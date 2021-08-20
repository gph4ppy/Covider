//
//  WelcomeScreenModel.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct WelcomeScreenModel: Identifiable {
    let id = UUID().uuidString
    let welcomeView: AnyView
    let title: String
    let description: String
}
