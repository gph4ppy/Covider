//
//  StopWatchView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI
import UserNotifications

struct StopWatchView: View {
    @State private var timer: Timer?            = Timer()
    @State private var notificationDate: Date   = Date()
    @Binding var progressTime: Int
    var hours: Int                              { progressTime / 3600 }
    var minutes: Int                            { (progressTime % 3600) / 60 }
    var seconds: Int                            { progressTime % 60 }

    var body: some View {
        HStack(spacing: 2) {
            StopWatchUnitView(timeUnit: hours)
            Text(":")
            StopWatchUnitView(timeUnit: minutes)
            Text(":")
            StopWatchUnitView(timeUnit: seconds)
        }
        .onAppear {
            start()
            requestPermission()
        }
        .onReceive(NotificationCenter.default.publisher(
            for: UIApplication.willResignActiveNotification
        )) { _ in
            movingToBackground()
        }
        .onReceive(NotificationCenter.default.publisher(
            for: UIApplication.didBecomeActiveNotification
        )) { _ in
            movingToForeground()
        }
    }

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            progressTime += 1
        }
    }

    func pause() {
        if let timer = timer {
            timer.invalidate()
        }
    }

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func movingToBackground() {
        print("Moving to the background")
        notificationDate = Date()
        pause()
    }

    func movingToForeground() {
        print("Moving to the foreground")
        let deltaTime: Int = Int(Date().timeIntervalSince(notificationDate))
        progressTime += deltaTime
        start()
    }
}

//class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
//    private let notificationManager = UNUserNotificationCenter.current()
//    @Published var notificationStatus: UNAuthorizationStatus?
//    
//    override init() {
//        super.init()
//        notificationManager.delegate = self
//        NotificationManager.requestNotificationPermission()
//    }
//    
//    public static func requestNotificationPermission() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//            if success {
//                print("All set!")
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    var statusString: String {
//        guard let status = notificationStatus else {
//            return "unknown"
//        }
//        
//        switch status {
//            case .notDetermined: return "notDetermined"
//            case .authorized: return "authorized"
//            case .ephemeral: return "ephemeral"
//            case .provisional: return "provisional"
//            case .denied: return "denied"
//            default: return "unknown"
//        }
//    }
//}
