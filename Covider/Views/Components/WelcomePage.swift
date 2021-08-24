//
//  CarouselView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct WelcomePage: View {
    let welcomeView: AnyView
    let title: String
    let description: String
    let size: CGSize
    
    var body: some View {
        VStack(spacing: 4) {
            Spacer()
            
            welcomeView
                .scaledToFit()
            
            Spacer()
            
            Text(title)
                .font(.largeTitle)
                .bold()
            
            ScrollView(.vertical, showsIndicators: false) {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(height: size.height / 3)
            .padding(.bottom)
        }
        .padding(.horizontal)
        .frame(width: size.width, height: size.height)
    }
}
