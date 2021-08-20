//
//  CarouselView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct CarouselView<Content: View, T: Identifiable>: View {
    @Binding var index: Int
    var spacing: CGFloat
    var trailingSpace: CGFloat
    
    var welcomeScreens: [T]
    var content: (T) -> Content
    
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    init(index: Binding<Int>, spacing: CGFloat = 6, trailingSpace: CGFloat = 8, welcomeScreens: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self._index = index
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self.welcomeScreens = welcomeScreens
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geom in
            let width = geom.size.width - trailingSpace + spacing
            
            HStack(spacing: 12) {
                ForEach(welcomeScreens) { screen in
                    content(screen)
                        .frame(width: geom.size.width - trailingSpace - spacing)
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -width) + offset)
            .gesture(
                DragGesture()
                    .updating($offset) { value, out, _ in
                        out = value.translation.width
                    }
                    .onEnded { value in
                        // Update Current Index
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundedIndex = progress.rounded()
                        self.currentIndex = max(min(currentIndex + Int(roundedIndex), welcomeScreens.count - 1), 0)
                        
                        // Update Index
                        currentIndex = index
                    }
                    .onChanged { value in
                        // Update Current Index
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundedIndex = progress.rounded()
                        self.index = max(min(currentIndex + Int(roundedIndex), welcomeScreens.count - 1), 0)
                    }
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
}
