//
//  SessionView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI
import MapKit

struct SessionView: View {
    @StateObject var locationManager                    = LocationManager()
    @State private var allPeopleCounter: Int            = 0
    @State private var vaccinatedCounter: Int           = 0
    @State private var unvaccinatedCounter: Int         = 0
    @State private var buttonSize: CGFloat              = 80
    @State private var showingConfirmationAlert: Bool   = false
    @State private var progressTime: Int                = 0
    @State private var allEntriesDate: [Date]           = []
    @State private var vaccinatedEntriesDate: [Date]    = []
    @State private var unvaccinatedEntriesDate: [Date]  = []
    @Environment(\.presentationMode) private var presentationMode
    var title: String
    var place: String
    var guardName: String
    var divisionOfVaccinated: Bool
    var startDate: Date
    
    var body: some View {
        VStack {
            Spacer()

            // Session View
            if divisionOfVaccinated {
                viewWithDivision
            } else {
                viewWithoutDivision
            }
            
            Spacer()
            
            // Timer
            StopWatchView(progressTime: $progressTime)
            
            // End Session Button
            Button(action: { self.showingConfirmationAlert = true }) {
                Text(LocalizedStrings.endSession)
                    .menuButtonStyle(background: Color(.red))
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showingConfirmationAlert, content: createAlert)
        .onAppear { self.buttonSize = divisionOfVaccinated ? 50 : 80 }
    }
}

// MARK: - Methods
extension SessionView {
    /// This method saves the duty.
    func saveDuty() {
        let latitude = locationManager.lastLocation?.coordinate.latitude
        let longitude = locationManager.lastLocation?.coordinate.longitude
        
        let duty = DutyViewModel(title: self.title,
                                 place: self.place,
                                 allPeople: Int32(self.allPeopleCounter),
                                 guardName: self.guardName,
                                 startDate: self.startDate,
                                 endDate: Date(),
                                 divisionOfVaccinated: self.divisionOfVaccinated,
                                 vaccinatedCount: Int32(self.vaccinatedCounter),
                                 unvaccinatedCount: Int32(self.unvaccinatedCounter),
                                 allEntriesDate: self.allEntriesDate,
                                 vaccinatedEntriesDate: self.vaccinatedEntriesDate,
                                 unvaccinatedEntriesDate: self.unvaccinatedEntriesDate,
                                 latitude: latitude.map(mapLocalization),
                                 longitude: longitude.map(mapLocalization))
        
        DutyViewModel.saveDuty(duty)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    /// This method converts the localization degrees (Double) to the String.
    /// - Parameter degrees: A latitude or longitude value specified in degrees.
    /// - Returns: String of a latitude or longitude.
    func mapLocalization(localization degrees: CLLocationDegrees) -> String {
        return String(degrees)
    }
    
    /// This method causes haptic vibrations and then increments the counter by 1.
    /// - Parameter counter: Counter of people entering to the place - according to the division of vaccinated.
    func add(to counter: inout Int) {
        let hapticPlus = UIImpactFeedbackGenerator(style: .heavy)
        hapticPlus.impactOccurred()
        counter += 1
    }
    
    /// This method causes haptic vibrations and then decrements the counter by 1.
    /// - Parameter counter: Counter of people entering to the place - according to the division of vaccinated.
    func subtract(from counter: inout Int) {
        let hapticMinus = UIImpactFeedbackGenerator(style: .medium)
        hapticMinus.impactOccurred()
        counter -= counter > 0 ? 1 : 0
    }
}

// MARK: - Views
extension SessionView {
    /// This method creates the confirmation alert.
    /// - Returns: Confirmation Alert
    func createAlert() -> Alert {
        Alert(title: Text(LocalizedStrings.confirm),
              message: Text(LocalizedStrings.endSessionDescription),
              primaryButton: .default(Text(LocalizedStrings.endSession), action: saveDuty),
              secondaryButton: .cancel(Text(LocalizedStrings.goBack)))
    }
    
    // A View which is shown when the user disabled the division of vaccinated.
    @ViewBuilder var viewWithoutDivision: some View {
        // Counter
        Text(String(allPeopleCounter))
            .font(.system(size: 90, weight: .bold, design: .default))
        
        Text(LocalizedStrings.peopleInThisPlace)
            .font(.largeTitle)
            .offset(y: -10)
        
        // Increment and decrement buttons
        HStack {
            // Minus button
            Button(action: { subtract(from: &allPeopleCounter) }) {
                Image(systemName: "minus")
                    .operationButtonStyle(size: buttonSize, color: .red)
            }
            
            Spacer()
            
            // Plus button
            Button(action: { add(to: &allPeopleCounter) }) {
                Image(systemName: "plus")
                    .operationButtonStyle(size: buttonSize, color: .green)
            }
        }
        .font(.largeTitle)
        .padding(.vertical)
        .shadow(radius: 5)
    }
    
    // A View which is shown when the user enabled the division of vaccinated.
    @ViewBuilder var viewWithDivision: some View {
        HStack {
            // All People Counter
            VStack(spacing: 20) {
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .font(.system(size: 100, weight: .ultraLight, design: .default))
                    .frame(height: 50)
                    .offset(y: 2)
                
                Text(String(allPeopleCounter))
                    .bold()
                    .foregroundColor(.blue)
                    .offset(y: 5)
            }
            
            Spacer()
            
            Divider()
                .frame(height: 150)
            
            Spacer()
            
            // Vaccinated Counter
            VStack(spacing: 20) {
                Image("vaccine_positive")
                    .resizable()
                    .frame(width: 60, height: 60)
                
                Text(String(vaccinatedCounter))
                    .bold()
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            Divider()
                .frame(height: 150)
            
            Spacer()
            
            // Unvaccinated Counter
            VStack(spacing: 20) {
                Image("vaccine_negative")
                    .resizable()
                    .frame(width: 60, height: 60)
                
                Text(String(unvaccinatedCounter))
                    .bold()
                    .foregroundColor(.red)
            }
        }
        .font(.title)
        .padding(.horizontal)
        
        // Increment and decrement buttons
        HStack {
            // Minus button
            Button(action: {
                let hapticMinus = UIImpactFeedbackGenerator(style: .soft)
                hapticMinus.impactOccurred()
                self.allPeopleCounter -= self.vaccinatedCounter > 0 ? 1 : 0
                self.vaccinatedCounter -= self.vaccinatedCounter > 0 ? 1 : 0
            }, label: {
                Image(systemName: "minus")
                    .operationButtonStyle(size: buttonSize, color: .red)
            })
            
            Spacer()
            
            Text(LocalizedStrings.vaccinated)
                .font(.title)
                .bold()
            
            Spacer()
            
            // Plus button
            Button(action: {
                let hapticPlus = UIImpactFeedbackGenerator(style: .light)
                hapticPlus.impactOccurred()
                self.allPeopleCounter += 1
                self.vaccinatedCounter += 1
            }, label: {
                Image(systemName: "plus")
                    .operationButtonStyle(size: buttonSize, color: .green)
            })
        }
        .padding(.vertical)
        .font(.largeTitle)
        
        HStack {
            // Minus button
            Button(action: {
                let hapticMinus = UIImpactFeedbackGenerator(style: .soft)
                hapticMinus.impactOccurred()
                self.allPeopleCounter -= self.unvaccinatedCounter > 0 ? 1 : 0
                self.unvaccinatedCounter -= self.unvaccinatedCounter > 0 ? 1 : 0
            }, label: {
                Image(systemName: "minus")
                    .operationButtonStyle(size: buttonSize, color: .red)
            })
            
            Spacer()
            
            Text(LocalizedStrings.unvaccinated)
                .font(.title)
                .bold()
            
            Spacer()
            
            // Plus button
            Button(action: {
                let hapticPlus = UIImpactFeedbackGenerator(style: .light)
                hapticPlus.impactOccurred()
                self.allPeopleCounter += 1
                self.unvaccinatedCounter += 1
            }, label: {
                Image(systemName: "plus")
                    .operationButtonStyle(size: buttonSize, color: .green)
            })
        }
        .padding(.vertical)
        .font(.largeTitle)
    }
}
