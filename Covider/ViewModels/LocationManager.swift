//
//  LocationManager.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 23/08/2021.
//

import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var lastLocation: CLLocation?
    let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        start()
    }
    
    func start() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
    }
}
