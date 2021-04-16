//
//  Project+CoreDataProperties.swift
//  SongSketch
//
//  Created by Samuel Garry on 4/15/21.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var name: String
    @NSManaged public var index: String
    @NSManaged public var sections: NSSet

}

// MARK: Generated accessors for sections
extension Project {

    @objc(addSectionsObject:)
    @NSManaged public func addToSections(_ value: Section)

    @objc(removeSectionsObject:)
    @NSManaged public func removeFromSections(_ value: Section)

    @objc(addSections:)
    @NSManaged public func addToSections(_ values: NSSet)

    @objc(removeSections:)
    @NSManaged public func removeFromSections(_ values: NSSet)

}

extension Project : Identifiable {

}
