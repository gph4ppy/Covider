//
//  NotificationManager.swift
//  Covider
//
//  Created by Jakub Dąbrowski on 29/08/2021.
//

import SwiftUI
import UserNotifications

final class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    public let notificationCenter = UNUserNotificationCenter.current()

    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    /// This method requests authorization and then, after obtaining permissions, executes the given code fragment.
    /// - Parameters:
    ///   - successful: An escaping closure, which is executed when the user allows sending notifications.
    ///   - failure: An escaping closure, which is executed when the user denies sending notifications.
    public func requestNotificationPermission(successful: @escaping () -> Void, failure: @escaping () -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                successful()
            } else if let error = error {
                print(error.localizedDescription)
            } else {
                failure()
            }
        }
    }
}
