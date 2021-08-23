//
//  DutySetupAlert.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct DutySetupAlert: View {
    @State private var title: String                = ""
    @State private var guardName: String            = ""
    @State private var placeName: String            = ""
    @State private var vaccinatedDivision: Bool     = true
    @State private var didStartSession: Bool        = false
    @Binding var isVisible: Bool
    var isDisabled: Bool {
        title.isEmpty || guardName.isEmpty || placeName.isEmpty ? true : false
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            // Title and description
            VStack(alignment: .center) {
                Text(LocalizedStrings.setupDutyTitle)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text(LocalizedStrings.setupDutyDescription)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            // Form
            VStack(spacing: 10) {
                // Title
                TextField(LocalizedStrings.title, text: $title)
                    .padding(.top)
                
                Divider()
                
                // Guard's name
                TextField(LocalizedStrings.guardName, text: $guardName)
                
                Divider()
                
                // Place - address, name, etc.
                TextField(LocalizedStrings.place, text: $placeName)
                
                Divider()
                
                // Division of the vaccinated people - Toggle
                Toggle(LocalizedStrings.vaccinatedDivision, isOn: $vaccinatedDivision)
                    .foregroundColor(Color(.systemGray3))
                    .padding(.trailing, 2)
                
                Spacer()
                
                // Buttons HStack
                HStack {
                    // Cancel button
                    Button(action: cancel) {
                        Text(LocalizedStrings.cancel)
                            .menuButtonStyle(background: .red)
                    }
                    
                    Spacer()

                    Button {
                        self.didStartSession = true
                        self.isVisible = false
                    } label: {
                        Text(LocalizedStrings.startDuty)
                            .menuButtonStyle(background: isDisabled ? .gray : .green)
                    }
                    .disabled(isDisabled)
                }
            }
        }
        .formStyle()
        .onChange(of: isVisible, perform: clearAlertFields)
        .fullScreenCover(isPresented: $didStartSession) {
            SessionView(
                title: title,
                place: placeName,
                guardName: guardName,
                divisionOfVaccinated: vaccinatedDivision,
                startDate: Date()
            )
        }
    }
}

// MARK: - Methods
extension DutySetupAlert {
    /// This method clears TextFields when the isVisible value changes.
    private func clearAlertFields(_: Bool) -> Void {
        if !didStartSession {
            self.title = ""
            self.guardName = ""
            self.placeName = ""
            self.vaccinatedDivision = true
        }
    }
    
    /// This method hides the keyboard and alert.
    private func cancel() {
        withAnimation {
            UIApplication.shared.endEditing()
            self.isVisible = false
        }
    }
}
