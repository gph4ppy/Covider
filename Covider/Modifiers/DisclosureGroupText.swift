//
//  DisclosureGroupText.swift
//  DisclosureGroupText
//
//  Created by Jakub Dąbrowski on 01/09/2021.
//

import SwiftUI

// DisclosureGroup Text Style
struct DisclosureGroupText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
    }
}

extension Text {
    func disclosureGroupText() -> some View {
        self
            .fontWeight(.regular)
            .multilineTextAlignment(.leading)
            .modifier(DisclosureGroupText())
    }
}
