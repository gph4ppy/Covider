//
//  WelcomeView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct WelcomeView: View {
    @State var currentIndex: Int = 0
    @State var welcomeScreens: [WelcomeScreenModel] = []
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    var body: some View {
        VStack {
            Text("Welcome to Covider")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            CarouselView(index: $currentIndex, welcomeScreens: welcomeScreens) { screen in
                GeometryReader { geom in
                    let size = geom.size
                    
                    VStack(spacing: 4) {
                        Spacer()
                        
                        screen.welcomeView
                            .aspectRatio(contentMode: .fit)
                            .padding()
                        
                        Spacer()
                        
                        Text(screen.title)
                            .font(.largeTitle)
                            .bold()
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            Text(screen.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: size.width - 40,
                               height: size.height / 3.5)
                    }
                    .frame(width: size.width)
                    .aspectRatio(contentMode: .fill)
                }
            }
            
            // Indicator
            HStack {
                ForEach(welcomeScreens.indices, id: \.self) { index in
                    Circle()
                        .fill(Color.primary.opacity(currentIndex == index ? 1 : 0.2))
                        .frame(width: 10, height: 10)
                        .scaleEffect(currentIndex == index ? 1.4 : 1)
                        .animation(.spring(), value: currentIndex == index)
                }
            }
            .padding(.vertical)
            
            Button("Start using app") {
                self.isFirstTime = false
            }
            .menuButtonStyle(background: .green)
        }
        .padding()
        .onAppear(perform: setupWelcomeScreens)
        .fullScreenCover(isPresented: .constant(!isFirstTime)) {
            EmptyView()
        }
    }
    
    func setupWelcomeScreens() {
        self.welcomeScreens = [
            WelcomeScreenModel(welcomeView: AnyView(leftRightArrows),
                               title: "Navigation",
                               description: "Swipe to the left or right to move around the menu."),
            WelcomeScreenModel(welcomeView: AnyView(heartRectangle),
                               title: "The purpose",
                               description: "Covider is a simple application that facilitates the work of security guards to watch places where counting entering people is necessary."),
            WelcomeScreenModel(welcomeView: AnyView(cloud),
                               title: "Head in the clouds?",
                               description: "With Covider, you don't have to remember how many people have entered - it's all on the screen! Speaking of clouds... Did you know that your duties are saved not only locally but also in iCloud, so they stay in sync across all your devices?"),
            WelcomeScreenModel(welcomeView: AnyView(buttons),
                               title: "You are in control",
                               description: "You decide when you press the add or subtract button. Did you tap the screen by accident? No problem - the buttons are large, but thanks to the haptic vibrations, you always know when you press them."),
            WelcomeScreenModel(welcomeView: AnyView(sparkles),
                               title: "Ready?",
                               description: "This is the end of the quick tutorial. Yes, it's that simple! You don't need anything else - Covider will take care of it all for you. All you have to do is press that beautiful green button...")
        ]
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
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

