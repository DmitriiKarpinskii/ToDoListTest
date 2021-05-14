//
//  Task+CoreDataProperties.swift
//  TODOList
//
//  Created by Dmitry Karpinsky on 14.05.2021.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String?
    @NSManaged public var descriptionTask: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var date: Date?

}

extension Task : Identifiable {

}
