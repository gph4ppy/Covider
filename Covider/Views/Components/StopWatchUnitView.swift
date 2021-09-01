//
//  StopWatchUnitView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct StopWatchUnitView: View {
    var timeUnit: Int
    
    /// Time unit expressed as String.
    /// - Includes "0" as prefix if this is less than 10
    private var timeUnitStr: String {
        let timeUnitStr = String(timeUnit)
        return timeUnit < 10 ? "0" + timeUnitStr : timeUnitStr
    }
    
    var body: some View {
        HStack (spacing: 2) {
            Text(timeUnitStr.substringIn(index: 0))
                .frame(width: 10)
            Text(timeUnitStr.substringIn(index: 1))
                .frame(width: 10)
        }
    }
}
