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
            Text(duty.title)
                .font(.title3)
            
            Text(duty.place)
                .font(.headline)
            
            Text("\(duty.startDate)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
