//
//  StopWatchView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI
import UserNotifications

struct StopWatchView: View {
    @State private var timer: Timer?                = Timer()
    @State private var notificationDate: Date       = Date()
    @Binding var progressTime: Int
    private let notificationManager: NotificationManager    = NotificationManager()
    private let willResign: NSNotification.Name             = UIApplication.willResignActiveNotification
    private let didBecomeActive: NSNotification.Name        = UIApplication.didBecomeActiveNotification
    private var hours: Int                                  { progressTime / 3600 }
    private var minutes: Int                                { (progressTime % 3600) / 60 }
    private var seconds: Int                                { progressTime % 60 }

    var body: some View {
        HStack(spacing: 2) {
            StopWatchUnitView(timeUnit: hours)
            Text(":")
            StopWatchUnitView(timeUnit: minutes)
            Text(":")
            StopWatchUnitView(timeUnit: seconds)
        }
        .onAppear(perform: start)
        .onReceive(NotificationCenter.default.publisher(for: willResign), perform: movingToBackground)
        .onReceive(NotificationCenter.default.publisher(for: didBecomeActive), perform: movingToForeground)
    }
}

// MARK: - Timer Management
private extension StopWatchView {
    /// This method requests notification authorization and starts a timer.
    func start() {
        // Request notification permission
        notificationManager.requestNotificationPermission {
            print("Notification permissions granted")
        } failure: {
            print("Notification permissions denied")
        }
        
        // Start the timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            progressTime += 1
        }
    }
    
    /// This method pauses a timer.
    func pause() {
        if let timer = timer {
            timer.invalidate()
        }
    }
}

// MARK: - Background Task Management
private extension StopWatchView {
    /// This method detects when an application has been moved to the background
    /// (e.g. when the screen is locked), pauses the timer, and saves the date
    /// when the task was performed.
    func movingToBackground(_:NotificationCenter.Publisher.Output) {
        print("Moving to the background")
        notificationDate = Date()
        pause()
    }
    
    /// This method detects when an application has been moved to the foreground
    /// (e.g. when the screen is unlocked), calculates the difference
    /// of the saved date when paused and the current date then adds
    /// the difference to the counter and starts the timer.
    func movingToForeground(_:NotificationCenter.Publisher.Output) {
        print("Moving to the foreground")
        let deltaTime: Int = Int(Date().timeIntervalSince(notificationDate))
        progressTime += deltaTime
        start()
    }
}
