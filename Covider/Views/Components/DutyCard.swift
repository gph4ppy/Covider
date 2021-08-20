//
//  DutyCard.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct DutyCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Title")
                .font(.title3)
            
            Text("Place 24, Ameno 20-300")
                .font(.headline)
            
            Text("Jacob")
                .font(.subheadline)
            
            Text(DateFormatter().string(from: Date()))
                .font(.subheadline)
        }
    }
}

struct DutyCard_Previews: PreviewProvider {
    static var previews: some View {
        DutyCard()
    }
}
