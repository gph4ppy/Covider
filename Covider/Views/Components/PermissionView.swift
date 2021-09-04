//
//  PermissionView.swift
//  Covider
//
//  Created by Jakub Dąbrowski on 29/08/2021.
//

import SwiftUI
import CoreLocation

struct PermissionView: View {
    @StateObject private var locationManager: LocationManager       = LocationManager()
    @State private var locationToggle: Bool                         = false
    @State private var notificationToggle: Bool                     = false
    @State private var showingAlert: Bool                           = false
    @State private var notificationStatus: UNAuthorizationStatus    = .notDetermined
    
    var body: some View {
        // Toggle Conditions
        let locationCondition: Binding<Bool> = {
            locationManager.locationStatus == .notDetermined ? $locationToggle : .constant(locationToggle)
        }()
        let notificationCondition: Binding<Bool> = {
            notificationStatus == .notDetermined ? $notificationToggle : .constant(notificationToggle)
        }()
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                // Location Toggle
                Toggle(LocalizedStrings.location, isOn: locationCondition)
                    .padding(.trailing, 2)
                    .foregroundColor(
                        setToggleTitleColor(locationStatus: self.locationManager.locationStatus)
                    )
                
                // Location Description
                DisclosureGroup(LocalizedStrings.locationPermissionTitle) {
                    Text(LocalizedStrings.locationPermissionDescription)
                        .disclosureGroupText()
                }
                .font(.subheadline.bold())
                
                Divider()
                    .padding()
                
                // Notifications Toggle
                Toggle(LocalizedStrings.notifications, isOn: notificationCondition)
                    .padding(.trailing, 2)
                    .foregroundColor(
                        setToggleTitleColor(notificationStatus: self.notificationStatus)
                    )
                
                // Notification Description
                DisclosureGroup(LocalizedStrings.notificationPermissionTitle) {
                    Text(LocalizedStrings.notificationPermissionDescription)
                        .disclosureGroupText()
                }
                .font(.subheadline.bold())
            }
        }
        .padding(.horizontal, 30)
        .frame(width: UIScreen.main.bounds.width - 60)
        .onChange(of: locationToggle, perform: requestLocation)
        .onChange(of: locationManager.locationStatus, perform: setLocationToggle)
        .onChange(of: notificationToggle, perform: requestNotifications)
        .onAppear(perform: assignToggleValues)
    }
}

// MARK: - Location Methods
private extension PermissionView {
    /// This method asks the user for permission to download the current location.
    func requestLocation(_:Bool) {
        self.locationManager.locationManager.requestWhenInUseAuthorization()
    }
    
    /// This method sets the toggle value based on the location authorization status.
    /// - Parameter status: [Optional] Status of location authorization
    func setLocationToggle(status: CLAuthorizationStatus?) {
        if let status = status {
            withAnimation {
                switch status {
                    case .authorizedAlways, .authorizedWhenInUse: self.locationToggle = true
                    case .denied, .restricted, .notDetermined: self.locationToggle = false
                    @unknown default: fatalError("Unknown location status")
                }
            }
        }
    }
}

// MARK: - Notifications Methods
private extension PermissionView {
    /// This method asks the user for permission to send notifications.
    func requestNotifications(_:Bool) {
        let manager = NotificationManager()
        
        // Request notification permission
        manager.requestNotificationPermission {
            // The user has allowed notifications.
            // Set toggle value to true, status to .authorized and label color to the green.
            self.notificationToggle = true
            self.notificationStatus = .authorized
            print("Notifications granted")
        } failure: {
            // The user has denied notifications.
            // Set toggle to value true, status to .authorized and label color to the green.
            self.notificationToggle = false
            self.notificationStatus = .denied
            print("Notifications denied")
        }
    }
}

// MARK: - General Methods
private extension PermissionView {
    /// This method restores the values of the toggles after restarting the application.
    func assignToggleValues() {
        let isLocationGranted = locationManager.locationStatus == .authorizedWhenInUse ? true : false
        self.locationToggle = isLocationGranted
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { permissions in
            self.notificationStatus = permissions.authorizationStatus
            
            let isAuthorized = permissions.authorizationStatus == .authorized
            let isProvisional = permissions.authorizationStatus == .provisional
            let isEphemeral = permissions.authorizationStatus == .ephemeral
            
            let isNotificationGranted = isAuthorized || isProvisional || isEphemeral ? true : false
            
            self.notificationToggle = isNotificationGranted
        }
    }
    
    /// This method changes the color of the label next to the toggle depending on the permissions.
    /// - Parameters:
    ///   - locationStatus: [Optional] Status of location authorization
    ///   - notificationStatus: [Optional] Status of notification authorization
    /// - Returns: A Color that will be used as a label text color next to the switch.
    func setToggleTitleColor(locationStatus: CLAuthorizationStatus? = nil, notificationStatus: UNAuthorizationStatus? = nil) -> Color {
        // Set the location label color
        if let locationStatus = locationStatus {
            switch locationStatus {
                case .authorizedWhenInUse, .authorizedAlways: return .green
                case .denied, .restricted: return .red
                case .notDetermined: return .primary
                @unknown default: fatalError("Unknown location status")
            }
        }
        
        // Set the notifications label color
        if let notificationStatus = notificationStatus {
            switch notificationStatus {
                case .authorized, .provisional, .ephemeral: return .green
                case .denied: return .red
                case .notDetermined: return .primary
                @unknown default: fatalError("Unknown notification status")
            }
        }
        
        return .primary
    }
}
