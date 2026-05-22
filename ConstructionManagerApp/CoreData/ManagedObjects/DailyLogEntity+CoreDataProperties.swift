//
//  DailyLogEntity+CoreDataProperties.swift
//  ConstructionManagerApp
//

import Foundation
import CoreData


extension DailyLogEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyLogEntity> {
        return NSFetchRequest<DailyLogEntity>(entityName: "DailyLogEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var notes: String?

}

extension DailyLogEntity : Identifiable {

}
