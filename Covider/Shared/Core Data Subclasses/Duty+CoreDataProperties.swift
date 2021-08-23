//
//  Duty+CoreDataProperties.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//
//

import Foundation
import CoreData

extension Duty {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Duty> {
        return NSFetchRequest<Duty>(entityName: "Duty")
    }

    @NSManaged public var title: String
    @NSManaged public var place: String
    @NSManaged public var allPeople: Int32
    @NSManaged public var guardName: String
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date
    @NSManaged public var divisionOfVaccinated: Bool
    @NSManaged public var vaccinatedCount: Int32
    @NSManaged public var unvaccinatedCount: Int32
    @NSManaged public var allEntriesDate: [Date]
    @NSManaged public var vaccinatedEntriesDate: [Date]
    @NSManaged public var unvaccinatedEntriesDate: [Date]
}

extension Duty : Identifiable {
}
