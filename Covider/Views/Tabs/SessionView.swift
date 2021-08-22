//
//  SessionView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct SessionView: View {
    @StateObject var locationManager = LocationManager()
    @State private var allPeopleCounter: Int            = 0
    @State private var vaccinatedCounter: Int           = 0
    @State private var unvaccinatedCounter: Int         = 0
    @State private var buttonSize: CGFloat              = 80
    @State private var showingConfirmationAlert: Bool   = false
    @Binding var title: String
    @Binding var place: String
    @Binding var guardName: String
    @Binding var divisionOfVaccinated: Bool
    @Environment(\.presentationMode) private var presentationMode
    var startDate: Date
    
    var body: some View {
        VStack {
            Spacer()
            
            if divisionOfVaccinated {
                viewWithDivision
            } else {
                viewWithoutDivision
            }
            
            Spacer()
            
            StopWatchView()
            
            Button {
                self.showingConfirmationAlert = true
            } label: {
                Text("End session")
                    .menuButtonStyle(background: Color(.red))
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.buttonSize = divisionOfVaccinated ? 50 : 80
        }
        .alert(isPresented: $showingConfirmationAlert) {
            Alert(title: Text("Confirm"),
                  message: Text("Are you sure you want to end this session?"),
                  primaryButton: .default(Text("End session"), action: {
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
                                             latitude: latitude.map(mapLocalization),
                                             longitude: longitude.map(mapLocalization))
                    
                    DutyViewModel.saveDuty(duty)
                    self.presentationMode.wrappedValue.dismiss()
                  }),
                  secondaryButton: .cancel(Text("Go back")))
        }
    }
    
    
    func mapLocalization(localization degrees: CLLocationDegrees) -> String {
        return String(degrees)
    }
    
    @ViewBuilder var viewWithoutDivision: some View {
        Text(String(allPeopleCounter))
            .font(.system(size: 90, weight: .bold, design: .default))
        
        Text("people in this place")
            .font(.largeTitle)
            .offset(y: -10)
        
        // Increment and decrement buttons
        HStack {
            // Minus button
            Button(action: {
                let hapticMinus = UIImpactFeedbackGenerator(style: .soft)
                hapticMinus.impactOccurred()
                self.allPeopleCounter -= self.allPeopleCounter > 0 ? 1 : 0
            }, label: {
                Image(systemName: "minus")
                    .frame(width: buttonSize, height: buttonSize)
                    .background(Color.red)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .font(.largeTitle)
            })
            
            Spacer()
            
            // Plus button
            Button(action: {
                let hapticPlus = UIImpactFeedbackGenerator(style: .light)
                hapticPlus.impactOccurred()
                self.allPeopleCounter += 1
            }, label: {
                Image(systemName: "plus")
                    .frame(width: buttonSize, height: buttonSize)
                    .background(Color.green)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .font(.largeTitle)
            })
        }
        .padding(.vertical)
        .shadow(radius: 5)
    }
    
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
                    .frame(width: buttonSize, height: buttonSize)
                    .background(Color.red)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .font(.largeTitle)
            })
            
            Spacer()
            
            Text("Vaccinated")
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
                    .frame(width: buttonSize, height: buttonSize)
                    .background(Color.green)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .font(.largeTitle)
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
                    .frame(width: buttonSize, height: buttonSize)
                    .background(Color.red)
                    .clipShape(Circle())
                    .foregroundColor(.white)
            })
            
            Spacer()
            
            Text("Unvaccinated")
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
                    .frame(width: buttonSize, height: buttonSize)
                    .background(Color.green)
                    .clipShape(Circle())
                    .foregroundColor(.white)
            })
        }
        .padding(.vertical)
        .font(.largeTitle)
    }
}

struct preview: PreviewProvider {
    static var previews: some View {
        SessionView(title: .constant("AAA"), place: .constant("AAA"), guardName: .constant("AAA"), divisionOfVaccinated: .constant(true), startDate: Date())
    }
}

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
            case .notDetermined: return "notDetermined"
            case .authorizedWhenInUse: return "authorizedWhenInUse"
            case .authorizedAlways: return "authorizedAlways"
            case .restricted: return "restricted"
            case .denied: return "denied"
            default: return "unknown"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
    }
}
