//
//  UIApplication+EndEditingAndHideKeyboard.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 21/08/2021.
//

import UIKit

extension UIApplication {
    /// This method hides a keyboard.
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
