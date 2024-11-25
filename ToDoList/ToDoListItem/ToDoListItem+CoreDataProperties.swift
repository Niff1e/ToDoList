//
//  ToDoListItem+CoreDataProperties.swift
//  ToDoList
//
//  Created by Pavel Maal on 22.11.24.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var isCompleted: Bool

}

extension ToDoListItem : Identifiable {

}
