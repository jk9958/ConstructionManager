//
//  DocumentPermissionEntity+CoreDataProperties.swift
//  ConstructionManagerApp
//
//  Created by DakshinAJK on 30/04/2025.
//
//

import Foundation
import CoreData


extension DocumentPermissionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocumentPermissionEntity> {
        return NSFetchRequest<DocumentPermissionEntity>(entityName: "DocumentPermissionEntity")
    }

    @NSManaged public var accessLevel: String?
    @NSManaged public var expiresAt: Date?
    @NSManaged public var grantedAt: Date?
    @NSManaged public var grantedBy: UUID?
    @NSManaged public var userId: UUID?
    @NSManaged public var document: DocumentEntity?

}

extension DocumentPermissionEntity : Identifiable {

}
