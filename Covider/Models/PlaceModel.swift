//
//  PlaceModel.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 22/08/2021.
//

import MapKit

struct Place: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
