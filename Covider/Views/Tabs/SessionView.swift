//
//  SessionView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI
import MapKit

struct SessionView: View {
    // Visual
    @State private var allPeopleCounter: Int                        = 0
    @State private var vaccinatedCounter: Int                       = 0
    @State private var unvaccinatedCounter: Int                     = 0
    @State private var buttonSize: CGFloat                          = 80
    @State private var showingAlert: Bool                           = false
    @State private var progressTime: Int                            = 0
    
    // Correct application work
    @StateObject var locationManager: LocationManager               = LocationManager()
    @Environment(\.presentationMode) private var presentationMode
    
    // Data to save
    @State private var allPeopleSum: Int                            = 0
    @State private var allVaccinatedSum: Int                        = 0
    @State private var allUnvaccinatedSum: Int                      = 0
    var title: String
    var place: String
    var guardName: String
    var divisionOfVaccinated: Bool
    var startDate: Date
    
    // Data to save for the charts
    @State private var allEntriesDate: [Date]                       = []
    @State private var vaccinatedEntriesDate: [Date]                = []
    @State private var unvaccinatedEntriesDate: [Date]              = []
    
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
            Button(action: { self.showingAlert = true }) {
                Text(LocalizedStrings.endSession)
                    .menuButtonStyle(background: Color(.red))
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showingAlert, content: createAlert)
        .onAppear(perform: startSession)
        .onDisappear(perform: locationManager.stop)
    }
}

// MARK: - Methods
private extension SessionView {
    /// This method adjusts the size of the buttons and starts updating the location.
    func startSession() {
        self.buttonSize = divisionOfVaccinated ? 50 : 80
        self.locationManager.start()
    }
    
    /// This method saves the duty.
    func saveDuty() {
        let lastLocation = locationManager.lastLocation?.coordinate
        let latitude = lastLocation?.latitude
        let longitude = lastLocation?.longitude
        
        let duty = DutyViewModel(title: self.title,
                                 place: self.place,
                                 allPeople: Int32(self.allPeopleSum),
                                 guardName: self.guardName,
                                 startDate: self.startDate,
                                 endDate: Date(),
                                 divisionOfVaccinated: self.divisionOfVaccinated,
                                 vaccinatedCount: Int32(self.allVaccinatedSum),
                                 unvaccinatedCount: Int32(self.allUnvaccinatedSum),
                                 allEntriesDate: self.allEntriesDate,
                                 vaccinatedEntriesDate: self.vaccinatedEntriesDate,
                                 unvaccinatedEntriesDate: self.unvaccinatedEntriesDate,
                                 latitude: latitude.map({ String($0) }),
                                 longitude: longitude.map({ String($0) }))
        
        DutyViewModel.saveDuty(duty)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    /// This method causes haptic vibrations and then increments the counter(s) by 1.
    /// - Parameter type: Counter type that will be increased:
    ///
    ///   - .none:              There is no division into vaccinated,
    ///                         increase only the all people counter
    ///
    ///   - .vaccinated:        There is a division into vaccinated,
    ///                         increase the all people and vaccinated counter
    ///
    ///   - .unvaccinated:      There is a division into vaccinated,
    ///                         increase the all people and unvaccinated counter
    ///
    func add(type: DivisionAction) {
        makeVibration(style: .heavy)
        
        self.allEntriesDate.append(Date())
        self.allPeopleCounter += 1
        self.allPeopleSum += 1
        
        switch type {
            case .vaccinated:
                self.vaccinatedEntriesDate.append(Date())
                self.vaccinatedCounter += 1
                self.allVaccinatedSum += 1
            case .unvaccinated:
                self.unvaccinatedEntriesDate.append(Date())
                self.unvaccinatedCounter += 1
                self.allUnvaccinatedSum += 1
            case .none:
                print("Incremented counter by 1")
        }
    }
    
    /// This method causes haptic vibrations and then decrements the counter(s) by 1.
    /// - Parameter type: Counter type that will be decreased:
    ///
    ///   - .none:              There is no division into vaccinated,
    ///                         decrease only the all people counter
    ///
    ///   - .vaccinated:        There is a division into vaccinated,
    ///                         decrease the all people and vaccinated counter
    ///
    ///   - .unvaccinated:      There is a division into vaccinated,
    ///                         decrease the all people and unvaccinated counter
    ///
    func subtract(type: DivisionAction) {
        makeVibration(style: .medium)
        
        // The condition that keeps:
        //  - A counter type (eg if it is equal to .none, execute action)
        //  - If the counters are equal to 0 - thanks to this they will not be the negative number.
        //  - When the counter enters 0, it will not subtract the person from all people
        //    (prevents the situation where the subtract button is tapped and instead of,
        //    for example, 100/100/0, the 95/100/0 is displayed).
        if (type == .vaccinated && vaccinatedCounter != 0) || (type == .unvaccinated && unvaccinatedCounter != 0) || type == .none {
            self.allPeopleCounter -= self.allPeopleCounter > 0 ? 1 : 0
            
            switch type {
                case .vaccinated:
                    self.vaccinatedCounter -= 1
                case .unvaccinated:
                    self.unvaccinatedCounter -= 1
                case .none:
                    print("Decremented counter by 1")
            }
        }
    }
    
    /// This method is used to generate the vibration of the device.
    func makeVibration(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let haptic = UIImpactFeedbackGenerator(style: style)
        haptic.impactOccurred()
    }
}

// MARK: - Views
private extension SessionView {
    /// This method creates the confirmation alert.
    /// - Returns: Confirmation Alert
    func createAlert() -> Alert {
        Alert(title: Text(LocalizedStrings.confirm),
              message: Text(LocalizedStrings.endSessionDescription),
              primaryButton: .default(Text(LocalizedStrings.endSession), action: saveDuty),
              secondaryButton: .cancel(Text(LocalizedStrings.goBack)))
    }
    
    /// This method creates a section with incrementation and decrementation buttons.
    /// - Parameters:
    ///   - title: Section title - displayed when there is a division into vaccinated,
    ///            by default set to empty string.
    ///   - decrementAction: Action performed after tapping the button with the plus symbol.
    ///   - incrementAction: Action performed after tapping the button with the minus symbol.
    /// - Returns: A section containing 2 buttons (plus and minus) and the title between them.
    @ViewBuilder func createOperationSection(title: String = "", decrementAction: @escaping () -> Void, incrementAction: @escaping () -> Void) -> some View {
        HStack {
            // Minus button
            Button(action: decrementAction) {
                Image(systemName: "minus")
                    .operationButtonStyle(size: buttonSize, color: .red)
            }
            
            Spacer()
            
            // Section title
            Text(title)
                .font(.title)
                .bold()
            
            Spacer()
            
            // Plus button
            Button(action: incrementAction) {
                Image(systemName: "plus")
                    .operationButtonStyle(size: buttonSize, color: .green)
            }
        }
        .padding(.vertical)
        .font(.largeTitle)
    }
    
    // A View which is shown when the user disabled the division into vaccinated.
    @ViewBuilder var viewWithoutDivision: some View {
        // All People Counter
        Text(String(allPeopleCounter))
            .font(.system(size: 90, weight: .bold, design: .default))
        
        Text(LocalizedStrings.peopleInThisPlace)
            .font(.largeTitle)
            .offset(y: -10)
        
        // Increment and decrement buttons
        createOperationSection(decrementAction: { subtract(type: .none) },
                               incrementAction: { add(type: .none) })
    }
    
    // A View which is shown when the user enabled the division into vaccinated.
    @ViewBuilder var viewWithDivision: some View {
        // Counters
        dividedCounters
        
        // --- Increment and decrement buttons ---
        // Vaccinated Section
        createOperationSection(title: LocalizedStrings.vaccinated,
                               decrementAction: { subtract(type: .vaccinated) },
                               incrementAction: { add(type: .vaccinated) })
        
        // Unvaccinated Section
        createOperationSection(title: LocalizedStrings.unvaccinated,
                               decrementAction: { subtract(type: .unvaccinated) },
                               incrementAction: { add(type: .unvaccinated) })
    }
    
    // A counter displayed when the user chose a division into vaccinated.
    @ViewBuilder var dividedCounters: some View {
        HStack {
            // All People Counter
            createDivisionCounterPart(image: "person",
                                      counter: allPeopleCounter,
                                      color: .blue)
            
            Spacer()
            
            Divider()
                .frame(height: 150)
            
            Spacer()
            
            // Vaccinated Counter
            createDivisionCounterPart(image: "vaccine_positive",
                                      counter: vaccinatedCounter,
                                      color: .green)
            
            Spacer()
            
            Divider()
                .frame(height: 150)
            
            Spacer()
            
            // Unvaccinated Counter
            createDivisionCounterPart(image: "vaccine_negative",
                                      counter: unvaccinatedCounter,
                                      color: .red)
        }
        .font(.title)
        .padding(.horizontal)
    }
    
    /// Creates a part of the counter, displayed when division into vaccinated and unvaccinated is enabled.
    /// - Parameters:
    ///   - name: A photo name from Assets.xcassets
    ///   - counter: Counter converted into a string, displays information about
    ///              how many people from a given division entered
    ///   - color: The color of the counter:
    ///
    ///     - blue:     all people
    ///     - green:    vaccinated people
    ///     - red:      unvaccinated people
    ///
    /// - Returns: A part of the counter with information about how many people from a given division entered
    @ViewBuilder func createDivisionCounterPart(image name: String, counter: Int, color: Color) -> some View {
        VStack(spacing: 20) {
            Image(name)
                .resizable()
                .frame(width: 60, height: 60)
                .colorInvertInDarkMode()
            
            Text(String(counter))
                .bold()
                .foregroundColor(color)
        }
    }
}
