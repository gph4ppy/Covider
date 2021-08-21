//
//  DetailView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 21/08/2021.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct DetailView: View {
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    let duty: Duty
    
    @ViewBuilder var mapOrEmptyRectangle: some View {
        if let latitudeString = duty.latitude,
           let longitudeString = duty.longitude,
           let latitude = Double(latitudeString),
           let longitude = Double(longitudeString) {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: latitude,
                    longitude: longitude
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.001,
                    longitudeDelta: 0.001
                )
            )
            
            Map(coordinateRegion: .constant(region), annotationItems: [
                    Place(coordinate: .init(latitude: latitude, longitude: longitude))
            ], annotationContent: { place in
                MapMarker(coordinate: place.coordinate)
            })
            .disabled(true)
        } else {
            Rectangle()
                .fill(Color.gray)
        }
    }
    
    var body: some View {
        ScrollView(.vertical) {
            mapOrEmptyRectangle
                .frame(height: 250)
                .mask(
                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]), startPoint: .top, endPoint: .bottom)
                )
            
            Text(duty.title)
                .font(.largeTitle)
                .bold()
                .offset(y: -30)
                .shadow(color: .primary, radius: 1)
            
            VStack(spacing: 14) {
                // All people
                HStack {
                    Text("All people")
                        .bold()
                    
                    Spacer()
                    
                    Text(String(duty.allPeople))
                }
                
                // if vaccinated
                // ...
                
                // Guard's name
                HStack {
                    Text("Guard")
                        .bold()
                    
                    Spacer()
                    
                    Text(duty.guardName)
                }
                
                // Place
                HStack {
                    Text("Place")
                        .bold()
                    
                    Spacer()
                    
                    Text(duty.place)
                }
                
                // Start Date
                HStack {
                    Text("Start date")
                        .bold()
                    
                    Spacer()
                    
                    Text(dateFormatter.string(from: duty.startDate))
                }
                
                // End Date
                HStack {
                    Text("End date")
                        .bold()
                    
                    Spacer()
                    
                    Text(dateFormatter.string(from: duty.endDate))
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}
