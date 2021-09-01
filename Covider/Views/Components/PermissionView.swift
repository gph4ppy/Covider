//
//  PermissionView.swift
//  Covider
//
//  Created by Jakub Dąbrowski on 29/08/2021.
//

import SwiftUI
import CoreLocation

struct PermissionView: View {
    @AppStorage("isFirstLocation") var isFirstLocation: Bool            = true
    @AppStorage("isFirstNotification") var isFirstNotification: Bool    = true
    @State var locationToggle: Bool                                     = false
    @State var notificationToggle: Bool                                 = false
    @State var showingAlert: Bool                                       = false
    @State var notificationStatus: UNAuthorizationStatus                = .notDetermined
    
    var body: some View {
        let locationStatus = CLLocationManager().authorizationStatus
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                Toggle(
                    LocalizedStrings.location,
                    isOn: isFirstLocation || locationStatus == .notDetermined ?
                    $locationToggle : .constant(locationToggle)
                )
                    .padding(.trailing, 2)
                    .foregroundColor(setToggleTitleColor(locationStatus: CLLocationManager().authorizationStatus))
                
                DisclosureGroup(LocalizedStrings.locationPermissionTitle) {
                    Text(LocalizedStrings.locationPermissionDescription)
                        .font(.footnote)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                }
                .font(.subheadline.bold())
                
                Divider()
                    .padding()
                
                Toggle(
                    LocalizedStrings.notifications,
                    isOn: isFirstNotification || notificationStatus == .notDetermined ?
                    $notificationToggle : .constant(notificationToggle)
                )
                    .padding(.trailing, 2)
                    .foregroundColor(setToggleTitleColor(notificationStatus: self.notificationStatus))
                
                DisclosureGroup(LocalizedStrings.notificationPermissionTitle) {
                    Text(LocalizedStrings.notificationPermissionDescription)
                        .font(.footnote)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                }
                .font(.subheadline.bold())
            }
        }
        .padding(.horizontal, 30)
        .frame(width: UIScreen.main.bounds.width - 60)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("The decision has been made"),
                  message: Text("You can always change these settings by going to the Settings -> Covider."),
                  dismissButton: .default(Text("OK"), action: {
                withAnimation {
                    switch CLLocationManager().authorizationStatus {
                        case .authorizedAlways, .authorizedWhenInUse: self.locationToggle = true
                        case .denied, .restricted, .notDetermined: self.locationToggle = false
                        @unknown default: fatalError("Unknown location status")
                    }
                }
                
                self.isFirstLocation = false
            }))
        }
        .onChange(of: locationToggle) { value in
            // Request Authorization (init)
            let manager = LocationManager()
            manager.locationManager.requestWhenInUseAuthorization()
            
            self.showingAlert = true
        }
        .onChange(of: notificationToggle, perform: requestNotifications)
        .onAppear {
            let isLocationGranted = locationStatus == .authorizedWhenInUse ? true : false
            self.locationToggle = isLocationGranted
            
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { permissions in
                self.notificationStatus = permissions.authorizationStatus
                
                let isNotificationGranted = permissions.authorizationStatus == .authorized || permissions.authorizationStatus == .provisional || permissions.authorizationStatus == .ephemeral ? true : false
                self.notificationToggle = isNotificationGranted
            }
        }
    }
    
    /// This method sets a toggle value based on authorization status.
    /// - Parameter manager: NotificationManager from which the status will be gathered
    private func setNotificationToggle(with manager: NotificationManager) {
        self.notificationToggle = notificationStatus == .authorized ? true : false
    }
    
    /// This method changes the color of the label next to the toggle depending on the permissions.
    /// - Parameters:
    ///   - locationStatus: [Optional] Status of location authorization
    ///   - notificationStatus: [Optional] Status of notification authorization
    /// - Returns: A Color that will be used as a label text color next to the switch.
    func setToggleTitleColor(locationStatus: CLAuthorizationStatus? = nil, notificationStatus: UNAuthorizationStatus? = nil) -> Color {
        if let locationStatus = locationStatus {
            switch locationStatus {
                case .authorizedWhenInUse, .authorizedAlways: return .green
                case .denied, .restricted: return .red
                case .notDetermined: return .primary
                @unknown default: fatalError("Unknown location status")
            }
        }
        
        if let notificationStatus = notificationStatus {
            switch notificationStatus {
                case .authorized, .provisional, .ephemeral: return .green
                case .denied: return .red
                case .notDetermined: return .primary
                @unknown default: fatalError("Unknown location status")
            }
        }
        
        return .primary
    }
    
    func requestNotifications(_:Bool) {
        let manager = NotificationManager()
        
        manager.requestNotificationPermission {
            self.notificationToggle = true
            self.notificationStatus = .authorized
            print("Notifications granted")
        } failure: { error in
            self.notificationToggle = false
            self.notificationStatus = .denied
            print(error.localizedDescription)
        }

        self.isFirstNotification = false
    }
}
