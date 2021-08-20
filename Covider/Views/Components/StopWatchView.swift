//
//  StopWatchView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct StopWatchView: View {
    @State private var progressTime = 0
    
    var hours: Int      { progressTime / 3600 }
    var minutes: Int    { (progressTime % 3600) / 60 }
    var seconds: Int    { progressTime % 60 }
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            progressTime += 1
        }
    }
    
    var body: some View {
        HStack(spacing: 2) {
            StopWatchUnitView(timeUnit: hours)
            Text(":")
            StopWatchUnitView(timeUnit: minutes)
            Text(":")
            StopWatchUnitView(timeUnit: seconds)
        }
        .onAppear(perform: { _ = timer })
    }
}

