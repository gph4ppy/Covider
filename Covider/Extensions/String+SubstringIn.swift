//
//  String+SubstringIn.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import Foundation

extension String {
    func substringIn(index: Int) -> String {
        let arrayString = Array(self)
        return String(arrayString[index])
    }
}
