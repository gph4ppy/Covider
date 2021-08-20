//
//  MenuButtonStyleModifier.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .cornerRadius(15)
            .foregroundColor(.white)
            .font(.headline)
    }
}

extension View {
    public func menuButtonStyle(background color: Color) -> some View {
        self.modifier(ButtonModifier(backgroundColor: color))
    }
}
