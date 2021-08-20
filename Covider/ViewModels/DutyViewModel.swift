//
//  DutyViewModel.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI
import CoreData

struct DutyViewModel {
    let title: String
    let place: String
    let allPeople: Int32
    let guardName: String
    let startDate: Date
    let endDate: Date
    
    // I am using the optional value, because if the user does not grant permission to read the current location,
    // DetailView will display a gray rectangle. I'm giving the user a choice.
    let latitude: String?
    let longitude: String?
    
    static public func saveDuty(_ duty: DutyViewModel) {
        withAnimation {
            let persistenceContainer = PersistenceController.shared.container
            let entity = Duty(context: persistenceContainer.viewContext)
            
            entity.title        = duty.title
            entity.place        = duty.place
            entity.allPeople    = duty.allPeople
            entity.guardName    = duty.guardName
            entity.startDate    = duty.startDate
            entity.endDate      = duty.endDate
            entity.latitude     = duty.latitude
            entity.longitude    = duty.longitude
            
            PersistenceController.shared.saveContext()
        }
    }
}

