//
//  NotificationManager.swift
//  Covider
//
//  Created by Jakub Dąbrowski on 29/08/2021.
//

import SwiftUI
import UserNotifications

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()

    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func requestNotificationPermission(successful: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                successful()
            } else if let error = error {
                failure(error)
            }
        }
    }
}
