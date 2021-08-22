//
//  DetailView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 21/08/2021.
//

import SwiftUI
import MapKit

struct DetailView: View {
    @State var data: [(title: String, dutyData: String)] = []
    let duty: Duty
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        ScrollView(.vertical) {
            mapOrEmptyRectangle
                .frame(height: 250)
                .mask(
                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]), startPoint: .top, endPoint: .bottom)
                )
            
            // Title
            Text(duty.title)
                .font(.largeTitle)
                .bold()
                .offset(y: -30)
                .shadow(color: .primary, radius: 1)
            
            // Duty Data
            VStack(spacing: 14) {
                ForEach(data, id: \.0) { data in
                    HStack {
                        Text(data.title)
                            .bold()
                        
                        Spacer()
                        
                        Text(data.dutyData)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear(perform: setupData)
    }
    
    func setupData() {
        self.data = [
            (title: "All people", dutyData: String(duty.allPeople)),
            (title: "Guard", dutyData: duty.guardName),
            (title: "Place", dutyData: duty.place),
            (title: "Start Date", dutyData: dateFormatter.string(from: duty.startDate)),
            (title: "End Date", dutyData: dateFormatter.string(from: duty.endDate)),
        ]
        
        if duty.divisionOfVaccinated {
            data.insert((title: "Vaccinated", dutyData: String(duty.vaccinatedCount)), at: 1)
            data.insert((title: "Unvaccinated", dutyData: String(duty.unvaccinatedCount)), at: 2)
        }
    }
    
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
}
