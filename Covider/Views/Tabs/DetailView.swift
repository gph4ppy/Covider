//
//  DetailView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 21/08/2021.
//

import SwiftUI
import MapKit

struct DetailView: View {
    @State private var data: [(title: String, dutyData: String)]    = []
    private let gradient                                            = Gradient(colors: [Color.black, Color.black.opacity(0)])
    private let dateFormatter: DateFormatter                        = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    private let calendar                                            = Calendar.current
    let duty: Duty
    
    var body: some View {
        let startHour = calendar.component(.hour, from: duty.startDate)
        let endHour = calendar.component(.hour, from: duty.endDate)
        
        ScrollView(.vertical) {
            mapOrEmptyRectangle
                .frame(height: 250)
                .mask(
                    LinearGradient(gradient: gradient,
                                   startPoint: .top,
                                   endPoint: .bottom)
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
            
            // Chart
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(startHour..<(endHour + Int.random(in: 1...24))) { hour in
                        let random = Int.random(in: 2...300)
                        VStack {
                            Spacer()
                            
                            Text(String(random))
                                .font(.footnote)
                                .rotationEffect(.degrees(-90))
                                .offset(y: 35)
                                .zIndex(1)
                                .offset(y: random > 60 ? 0 : -35)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.blue)
                                .frame(width: 30, height: CGFloat(random) * 0.5)
                            
                            Text(String(hour > 24 ? hour - 24 : hour))
                                .font(.footnote)
                                .frame(height: 20)
                        }
                    }
                }
            }
            .padding()
            .padding(.top, 20)
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear(perform: setupData)
    }
}

// MARK: - Methods
extension DetailView {
    /// This method prepares data to display.
    private func setupData() {
        self.data = [
            (title: LocalizedStrings.allPeople, dutyData: String(duty.allPeople)),
            (title: LocalizedStrings.guardString, dutyData: duty.guardName),
            (title: LocalizedStrings.place, dutyData: duty.place),
            (title: LocalizedStrings.startDate, dutyData: dateFormatter.string(from: duty.startDate)),
            (title: LocalizedStrings.endDate, dutyData: dateFormatter.string(from: duty.endDate)),
        ]
        
        if duty.divisionOfVaccinated {
            data.insert((title: LocalizedStrings.vaccinated, dutyData: String(duty.vaccinatedCount)), at: 1)
            data.insert((title: LocalizedStrings.unvaccinated, dutyData: String(duty.unvaccinatedCount)), at: 2)
        }
    }
}

// MARK: - Views
extension DetailView {
    // If the user allows downloading the location, the map with the place of duty is displayed.
    // If the user does not allow downloading location, a gray rectangle is displayed.
    @ViewBuilder private var mapOrEmptyRectangle: some View {
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
