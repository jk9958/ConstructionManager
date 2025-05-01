//
//  ProjectEntity+CoreDataProperties.swift
//  ConstructionManagerApp
//
//  Created by DakshinAJK on 30/04/2025.
//
//

import Foundation
import CoreData


extension ProjectEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProjectEntity> {
        return NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
    }

    @NSManaged public var budget: Double
    @NSManaged public var budgetData: Data?
    @NSManaged public var createdAt: Date?
    @NSManaged public var documentsData: Data?
    @NSManaged public var expectedEndDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var location: String?
    @NSManaged public var metadataData: Data?
    @NSManaged public var name: String?
    @NSManaged public var priority: String?
    @NSManaged public var projectDescription: String?
    @NSManaged public var scheduleData: Data?
    @NSManaged public var startDate: Date?
    @NSManaged public var status: String?
    @NSManaged public var teamData: Data?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var documents: NSSet?
    @NSManaged public var expenses: NSSet?
    @NSManaged public var tasks: NSSet?
    @NSManaged public var team: TeamEntity?
}

// MARK: Generated accessors for documents
extension ProjectEntity {

    @objc(addDocumentsObject:)
    @NSManaged public func addToDocuments(_ value: DocumentEntity)

    @objc(removeDocumentsObject:)
    @NSManaged public func removeFromDocuments(_ value: DocumentEntity)

    @objc(addDocuments:)
    @NSManaged public func addToDocuments(_ values: NSSet)

    @objc(removeDocuments:)
    @NSManaged public func removeFromDocuments(_ values: NSSet)

}

// MARK: Generated accessors for expenses
extension ProjectEntity {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: ExpenseEntity)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: ExpenseEntity)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

// MARK: Generated accessors for tasks
extension ProjectEntity {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TaskEntity)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TaskEntity)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension ProjectEntity : Identifiable {

}
