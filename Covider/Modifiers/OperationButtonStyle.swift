//
//  OperationButtonStyle.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 23/08/2021.
//

import SwiftUI

// Plus and Minus Button Style
struct OperationButtonStyle: ViewModifier {
    let size: CGFloat
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .frame(width: size, height: size)
            .background(color)
            .clipShape(Circle())
            .foregroundColor(.white)
    }
}

extension View {
    func operationButtonStyle(size: CGFloat, color: Color) -> some View {
        self.modifier(OperationButtonStyle(size: size, color: color))
    }
}
