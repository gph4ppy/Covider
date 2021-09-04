//
//  ColorInvertInDarkMode.swift
//  Covider
//
//  Created by Jakub Dąbrowski on 03/09/2021.
//

import SwiftUI

// Inverts the colors of the view in a dark mode
struct ColorInvertInDarkMode: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        if colorScheme == .dark {
            content.colorInvert()
        } else {
            content
        }
    }
}

extension View {
    func colorInvertInDarkMode() -> some View {
        self.modifier(ColorInvertInDarkMode())
    }
}
