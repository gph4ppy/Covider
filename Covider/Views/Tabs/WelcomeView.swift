//
//  WelcomeView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct WelcomeView: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    var body: some View {
        // I use this array as computed property, because on a physical device,
        // when I assigned the content of the table in .onAppear,
        // it threw a fatalError that indexOutOfRange.
        let welcomeScreens: [WelcomeScreenModel] = {
            [
                WelcomeScreenModel(welcomeView: AnyView(leftRightArrows),
                                   title: LocalizedStrings.navigation,
                                   description: LocalizedStrings.welcomeScreenDescription1),
                WelcomeScreenModel(welcomeView: AnyView(heartRectangle),
                                   title: LocalizedStrings.thePurpose,
                                   description: LocalizedStrings.welcomeScreenDescription2),
                WelcomeScreenModel(welcomeView: AnyView(cloud),
                                   title: LocalizedStrings.headInTheClouds,
                                   description: LocalizedStrings.welcomeScreenDescription3),
                WelcomeScreenModel(welcomeView: AnyView(buttons),
                                   title: LocalizedStrings.youAreInControl,
                                   description: LocalizedStrings.welcomeScreenDescription4),
                WelcomeScreenModel(welcomeView: AnyView(PermissionView()),
                                   title: LocalizedStrings.permissions,
                                   description: LocalizedStrings.welcomeScreenDescription5),
                WelcomeScreenModel(welcomeView: AnyView(sparkles),
                                   title: LocalizedStrings.ready,
                                   description: LocalizedStrings.welcomeScreenDescription6)
            ]
        }()
        
        VStack {
            // Title
            Text(LocalizedStrings.welcomeToCovider)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            // Carousel View with tutorial
            GeometryReader { geom in
                TabView {
                    ForEach(welcomeScreens, id: \.self) { screen in
                        WelcomePage(welcomeView: AnyView(screen.welcomeView),
                                    title: screen.title,
                                    description: screen.description,
                                    size: geom.size)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
            
            // Start using app button
            Button(action: { self.isFirstTime = false }) {
                Text(LocalizedStrings.startUsingApp)
                    .menuButtonStyle(background: .green)
            }
        }
        .padding()
        .fullScreenCover(isPresented: .constant(!isFirstTime)) { HomeView() }
    }
}
