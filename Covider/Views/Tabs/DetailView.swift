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
        ScrollView(.vertical) {
            // Map / Gray Rectangle
            mapOrEmptyRectangle
                .frame(height: 250)
                .mask(
                    // A gradient mask, which fades out the bottom side of the above view
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
            
            // Bar Chart
            chart
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear(perform: setupData)
    }
}

// MARK: - Methods
private extension DetailView {
    /// This method prepares data to display.
    private func setupData() {
        // Assign data to the array with data
        self.data = [
            (title: LocalizedStrings.allPeople, dutyData: String(duty.allPeople)),
            (title: LocalizedStrings.guardString, dutyData: duty.guardName),
            (title: LocalizedStrings.place, dutyData: duty.place),
            (title: LocalizedStrings.startDate, dutyData: dateFormatter.string(from: duty.startDate)),
            (title: LocalizedStrings.endDate, dutyData: dateFormatter.string(from: duty.endDate)),
        ]
        
        // If there is a division into vaccinated, add data about vaccinated people to the above array.
        if duty.divisionOfVaccinated {
            data.insert((title: LocalizedStrings.vaccinated, dutyData: String(duty.vaccinatedCount)), at: 1)
            data.insert((title: LocalizedStrings.unvaccinated, dutyData: String(duty.unvaccinatedCount)), at: 2)
        }
    }
    
    /// This method counts all the occurrences of an hour in the table with the dates of entering persons.
    /// - Parameters:
    ///   - hour: An hour that is currently analyzed
    ///   - array: An array with dates of entering persons
    /// - Returns: An integer representing the number of people who have entered at a given hour
    func sumEntries(hour: Int, in array: [Date]) -> Int {
        array.filter {
            Calendar.current.component(.hour, from: $0) == hour
        }.count
    }
}

// MARK: - Views
private extension DetailView {
    // If the user allows downloading the location, the map with the place of duty is displayed.
    // If the user does not allow downloading location, a gray rectangle is displayed.
    @ViewBuilder var mapOrEmptyRectangle: some View {
        if let latitudeString = duty.latitude,
           let longitudeString = duty.longitude,
           let latitude = Double(latitudeString),
           let longitude = Double(longitudeString) {
            // Create region
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            let region = MKCoordinateRegion(center: center, span: span)
            
            // Return map
            Map(coordinateRegion: .constant(region), annotationItems: [
                Place(coordinate: .init(latitude: latitude, longitude: longitude))
            ], annotationContent: { place in
                MapMarker(coordinate: place.coordinate)
            })
            .disabled(true)
        } else {
            // Gray rectangle
            Rectangle()
                .fill(Color.gray)
        }
    }
    
    // A chart of people who have entered (divided down by hour).
    @ViewBuilder var chart: some View {
        let startHour = calendar.component(.hour, from: duty.startDate)
        let endHour = calendar.component(.hour, from: duty.endDate)
        
        VStack {
            // Chart Title
            Text(LocalizedStrings.entriesChart)
                .font(.title3)
                .fontWeight(.semibold)
            
            // Bar Chart
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(startHour..<(endHour + 1)) { hour in
                        let allEntriesSum = sumEntries(hour: hour, in: duty.allEntriesDate)
                        let vaccinatedEntriesSum = sumEntries(hour: hour, in: duty.vaccinatedEntriesDate)
                        let unvaccinatedEntriesSum = sumEntries(hour: hour, in: duty.unvaccinatedEntriesDate)
                        
                        VStack {
                            Spacer()
                            
                            // Bars
                            if duty.divisionOfVaccinated {
                                // A chart with division of vaccinated.
                                HStack(alignment: .bottom, spacing: 0) {
                                    // All People
                                    createChartBar(from: allEntriesSum, color: .blue)
                                    
                                    // Vaccinated
                                    createChartBar(from: vaccinatedEntriesSum, color: .green)
                                    
                                    // Unvaccinated
                                    createChartBar(from: unvaccinatedEntriesSum, color: .red)
                                }
                            } else {
                                // A chart of all people - without division of vaccinated.
                                createChartBar(from: allEntriesSum,
                                               color: .blue,
                                               division: false)
                            }
                            
                            // Hour
                            Text(String(hour >= 24 ? hour - 24 : hour))
                                .font(.footnote)
                                .frame(height: 20)
                        }
                    }
                }
            }
        }
        .padding()
        .padding(.top, 20)
    }
    
    /// This method creates a bar for the chart.
    /// - Parameters:
    ///   - data: The number of people who entered at the given hour
    ///   - color: A color of the bar:
    ///
    ///     - blue:     all people
    ///     - green:    vaccinated people
    ///     - red:      unvaccinated people
    ///
    ///     Green and red appear only when there is a division into vaccinated.
    ///
    ///   - division: Contains information on whether there is a division into vaccinated. By default set to true.
    /// - Returns: A chart bar for given hour
    @ViewBuilder func createChartBar(from data: Int, color: Color, division: Bool = true) -> some View {
        VStack {
            // A label representing a number of people that had entered at that hour.
            Text(String(data))
                .font(.footnote)
                .rotationEffect(.degrees(-90))
                .zIndex(1)
                .foregroundColor(division ? color : .primary)
            
            // Chart Bar
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: division ? 10 : 30,
                       height: CGFloat(data) * 0.5)
        }
    }
}
