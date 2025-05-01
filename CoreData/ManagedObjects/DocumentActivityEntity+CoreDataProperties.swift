//
//  DocumentActivityEntity+CoreDataProperties.swift
//  ConstructionManagerApp
//
//  Created by DakshinAJK on 30/04/2025.
//
//

import Foundation
import CoreData


extension DocumentActivityEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocumentActivityEntity> {
        return NSFetchRequest<DocumentActivityEntity>(entityName: "DocumentActivityEntity")
    }

    @NSManaged public var activityType: String?
    @NSManaged public var id: UUID?
    @NSManaged public var metadata: NSObject?
    @NSManaged public var timestamp: Date?
    @NSManaged public var userId: UUID?
    @NSManaged public var document: DocumentEntity?

}

extension DocumentActivityEntity : Identifiable {

}
