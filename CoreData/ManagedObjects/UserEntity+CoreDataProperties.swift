//
//  UserEntity+CoreDataProperties.swift
//  ConstructionManagerApp
//
//  Created by DakshinAJK on 30/04/2025.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var department: String?
    @NSManaged public var displayName: String?
    @NSManaged public var email: String?
    @NSManaged public var id: UUID?
    @NSManaged public var jobTitle: String?
    @NSManaged public var lastLoginAt: Date?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var preferences: NSObject?
    @NSManaged public var role: String?
    @NSManaged public var status: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var assignedTasks: NSSet?
    @NSManaged public var teams: NSSet?

}

// MARK: Generated accessors for assignedTasks
extension UserEntity {

    @objc(addAssignedTasksObject:)
    @NSManaged public func addToAssignedTasks(_ value: TaskEntity)

    @objc(removeAssignedTasksObject:)
    @NSManaged public func removeFromAssignedTasks(_ value: TaskEntity)

    @objc(addAssignedTasks:)
    @NSManaged public func addToAssignedTasks(_ values: NSSet)

    @objc(removeAssignedTasks:)
    @NSManaged public func removeFromAssignedTasks(_ values: NSSet)

}

// MARK: Generated accessors for teams
extension UserEntity {

    @objc(addTeamsObject:)
    @NSManaged public func addToTeams(_ value: TeamEntity)

    @objc(removeTeamsObject:)
    @NSManaged public func removeFromTeams(_ value: TeamEntity)

    @objc(addTeams:)
    @NSManaged public func addToTeams(_ values: NSSet)

    @objc(removeTeams:)
    @NSManaged public func removeFromTeams(_ values: NSSet)

}

extension UserEntity : Identifiable {

}
