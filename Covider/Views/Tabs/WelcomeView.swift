//
//  WelcomeView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct WelcomeView: View {
    @State var welcomeScreens: [WelcomeScreenModel]             = []
    @AppStorage("isFirstTime") private var isFirstTime: Bool    = true
    
    var body: some View {
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
        .onAppear(perform: setupWelcomeScreens)
        .fullScreenCover(isPresented: .constant(!isFirstTime)) { HomeView() }
    }
    
    func setupWelcomeScreens() {
        self.welcomeScreens = [
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
            WelcomeScreenModel(welcomeView: AnyView(sparkles),
                               title: LocalizedStrings.ready,
                               description: LocalizedStrings.welcomeScreenDescription5)
        ]
    }
}

// MARK: - Welcome Views
extension WelcomeView {
    // 1st
    @ViewBuilder var leftRightArrows: some View {
        HStack {
            Image(systemName: "arrowshape.turn.up.backward")
            Spacer().padding()
            Image(systemName: "arrowshape.turn.up.right")
        }
        .font(.system(size: 94, weight: .thin, design: .default))
    }
    
    // 2nd
    @ViewBuilder var heartRectangle: some View {
        Image(systemName: "heart.text.square")
            .font(.system(size: 150, weight: .ultraLight, design: .default))
    }
    
    // 3rd
    @ViewBuilder var cloud: some View {
        Image(systemName: "cloud.sun")
            .font(.system(size: 150, weight: .ultraLight, design: .default))
    }
    
    // 4th
    @ViewBuilder var buttons: some View {
        HStack {
            Image(systemName: "minus.circle")
            Spacer().padding()
            Image(systemName: "plus.circle")
        }
        .font(.system(size: 94, weight: .thin, design: .default))
    }
    
    // 5th
    @ViewBuilder var sparkles: some View {
        Image(systemName: "hands.sparkles")
            .font(.system(size: 150, weight: .ultraLight, design: .default))
    }
}
