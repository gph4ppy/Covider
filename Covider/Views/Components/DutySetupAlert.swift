//
//  DutySetupAlert.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct DutySetupAlert: View {
    @State var title: String = ""
    @State var guardName: String = ""
    @State var placeName: String = ""
    @State var vaccinatedDivision: Bool = true
    @Binding var isVisible: Bool
    var isDisabled: Bool {
        title.isEmpty || guardName.isEmpty || placeName.isEmpty ? true : false
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center) {
                Text("Setup Duty")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("This view is used to configure your duty. Fill in the following data.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 10) {
                TextField("Title", text: $title)
                    .padding(.top)
                
                Divider()
                
                TextField("Guard's name", text: $guardName)
                
                Divider()
                
                TextField("Name of the place", text: $placeName)
                
                Divider()
                
                Toggle("Vaccinated Division", isOn: $vaccinatedDivision)
                    .foregroundColor(Color(.systemGray3))
                    .padding(.trailing, 2)
                
                Spacer()
                
                HStack {
                    Button {
                        withAnimation {
                            self.isVisible = false
                        }
                    } label: {
                        Text("Cancel")
                            .menuButtonStyle(background: .red)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SessionView(
                        title: $title,
                        place: $placeName,
                        guardName: $guardName,
                        divisionOfVaccinated: $vaccinatedDivision,
                        startDate: Date())
                    ) {
                        Text("Start Duty")
                            .menuButtonStyle(background: isDisabled ? .gray : .green)
                    }
                    .disabled(isDisabled)
                }
            }
        }
        .formStyle()
        .onChange(of: isVisible) { _ in
            self.title = ""
            self.guardName = ""
            self.placeName = ""
            self.vaccinatedDivision = true
        }
    }
}

struct DutySetupAlert_Previews: PreviewProvider {
    static var previews: some View {
        DutySetupAlert(isVisible: .constant(true))
    }
}
