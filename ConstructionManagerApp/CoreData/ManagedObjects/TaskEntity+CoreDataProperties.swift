//
//  TaskEntity+CoreDataProperties.swift
//  ConstructionManagerApp
//
//  Created by DakshinAJK on 01/05/2025.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var completionPercentage: Double
    @NSManaged public var createdAt: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var priority: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var status: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var assignedTo: NSSet?
    @NSManaged public var dependencies: NSSet?
    @NSManaged public var dependentTasks: NSSet?
    @NSManaged public var project: ProjectEntity?

}

// MARK: Generated accessors for assignedTo
extension TaskEntity {

    @objc(addAssignedToObject:)
    @NSManaged public func addToAssignedTo(_ value: UserEntity)

    @objc(removeAssignedToObject:)
    @NSManaged public func removeFromAssignedTo(_ value: UserEntity)

    @objc(addAssignedTo:)
    @NSManaged public func addToAssignedTo(_ values: NSSet)

    @objc(removeAssignedTo:)
    @NSManaged public func removeFromAssignedTo(_ values: NSSet)

}

// MARK: Generated accessors for dependencies
extension TaskEntity {

    @objc(addDependenciesObject:)
    @NSManaged public func addToDependencies(_ value: TaskEntity)

    @objc(removeDependenciesObject:)
    @NSManaged public func removeFromDependencies(_ value: TaskEntity)

    @objc(addDependencies:)
    @NSManaged public func addToDependencies(_ values: NSSet)

    @objc(removeDependencies:)
    @NSManaged public func removeFromDependencies(_ values: NSSet)

}

// MARK: Generated accessors for dependentTasks
extension TaskEntity {

    @objc(addDependentTasksObject:)
    @NSManaged public func addToDependentTasks(_ value: TaskEntity)

    @objc(removeDependentTasksObject:)
    @NSManaged public func removeFromDependentTasks(_ value: TaskEntity)

    @objc(addDependentTasks:)
    @NSManaged public func addToDependentTasks(_ values: NSSet)

    @objc(removeDependentTasks:)
    @NSManaged public func removeFromDependentTasks(_ values: NSSet)

}

extension TaskEntity : Identifiable {

}
