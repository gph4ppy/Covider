//
//  MainView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI
import CoreData

struct MainView: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    var body: some View {
        if isFirstTime {
            WelcomeView()
        } else {
            HomeView()
        }
    }
}
