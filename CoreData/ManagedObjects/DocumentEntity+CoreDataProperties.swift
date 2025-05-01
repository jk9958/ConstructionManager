//
//  DocumentEntity+CoreDataProperties.swift
//  ConstructionManagerApp
//
//  Created by DakshinAJK on 30/04/2025.
//
//

import Foundation
import CoreData


extension DocumentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocumentEntity> {
        return NSFetchRequest<DocumentEntity>(entityName: "DocumentEntity")
    }

    @NSManaged public var data: Data?
    @NSManaged public var documentDescription: String?
    @NSManaged public var documentType: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var projectId: UUID?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var activities: NSSet?
    @NSManaged public var permissions: NSSet?
    @NSManaged public var project: ProjectEntity?

}

// MARK: Generated accessors for activities
extension DocumentEntity {

    @objc(addActivitiesObject:)
    @NSManaged public func addToActivities(_ value: DocumentActivityEntity)

    @objc(removeActivitiesObject:)
    @NSManaged public func removeFromActivities(_ value: DocumentActivityEntity)

    @objc(addActivities:)
    @NSManaged public func addToActivities(_ values: NSSet)

    @objc(removeActivities:)
    @NSManaged public func removeFromActivities(_ values: NSSet)

}

// MARK: Generated accessors for permissions
extension DocumentEntity {

    @objc(addPermissionsObject:)
    @NSManaged public func addToPermissions(_ value: DocumentPermissionEntity)

    @objc(removePermissionsObject:)
    @NSManaged public func removeFromPermissions(_ value: DocumentPermissionEntity)

    @objc(addPermissions:)
    @NSManaged public func addToPermissions(_ values: NSSet)

    @objc(removePermissions:)
    @NSManaged public func removeFromPermissions(_ values: NSSet)

}

extension DocumentEntity : Identifiable {

}
