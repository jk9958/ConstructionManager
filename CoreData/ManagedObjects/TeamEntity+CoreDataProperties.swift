//
//  TeamEntity+CoreDataProperties.swift
//  ConstructionManagerApp
//
//  Created by DakshinAJK on 30/04/2025.
//
//

import Foundation
import CoreData


extension TeamEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TeamEntity> {
        return NSFetchRequest<TeamEntity>(entityName: "TeamEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var createdBy: UUID?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var members: NSSet?
    @NSManaged public var projects: NSSet?

}

// MARK: Generated accessors for members
extension TeamEntity {

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: UserEntity)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: UserEntity)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)

}

// MARK: Generated accessors for projects
extension TeamEntity {

    @objc(addProjectsObject:)
    @NSManaged public func addToProjects(_ value: ProjectEntity)

    @objc(removeProjectsObject:)
    @NSManaged public func removeFromProjects(_ value: ProjectEntity)

    @objc(addProjects:)
    @NSManaged public func addToProjects(_ values: NSSet)

    @objc(removeProjects:)
    @NSManaged public func removeFromProjects(_ values: NSSet)

}

extension TeamEntity : Identifiable {

}
