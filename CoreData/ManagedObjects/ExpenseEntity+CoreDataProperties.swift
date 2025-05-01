//
//  ExpenseEntity+CoreDataProperties.swift
//  ConstructionManagerApp
//
//  Created by DakshinAJK on 30/04/2025.
//
//

import Foundation
import CoreData


extension ExpenseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseEntity> {
        return NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var date: Date?
    @NSManaged public var expenseDescription: String?
    @NSManaged public var id: UUID?
    @NSManaged public var receiptURL: String?
    @NSManaged public var status: String?
    @NSManaged public var submittedBy: String?
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var project: ProjectEntity?

}

extension ExpenseEntity : Identifiable {

}
