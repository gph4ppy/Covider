//
//  DutyCard.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct DutyCard: View {
    let duty: Duty
    
    var body: some View {
        VStack(alignment: .leading) {
            // Title of the saved duty
            Text(duty.title)
                .font(.title3)
            
            // Place of the saved duty
            Text(duty.place)
                .font(.headline)
            
            // Start date of the saved duty
            Text("\(duty.startDate)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
