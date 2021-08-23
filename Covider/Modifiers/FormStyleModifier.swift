//
//  FormStyleModifier.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

// A modifier which returns a view similar to Form
struct FormStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .padding()
            .frame(height: 440)
            .shadow(radius: 10)
    }
}

extension View {
    public func formStyle() -> some View {
        self.modifier(FormStyleModifier())
    }
}
