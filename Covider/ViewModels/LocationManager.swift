//
//  LocationManager.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 23/08/2021.
//

import SwiftUI
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var lastLocation: CLLocation?
    @Published var locationStatus: CLAuthorizationStatus?
    public let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - Session Management
    /// This method requests authorization and starts updating the user's location.
    public func start() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /// This method stops updating the user's location.
    public func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Data Update
    // Invoked when the authorization status changes for this application.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
    }
    
    // Invoked when new locations are available.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
    }
}
