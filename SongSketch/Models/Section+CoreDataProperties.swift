//
//  Section+CoreDataProperties.swift
//  SongSketch
//
//  Created by Samuel Garry on 4/10/21.
//
//

import Foundation
import CoreData


extension Section {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Section> {
        return NSFetchRequest<Section>(entityName: "Section")
    }

    @NSManaged public var index: Int64
    @NSManaged public var name: String
    @NSManaged public var numOfTakes: Int64
    @NSManaged public var position: Int64
    @NSManaged public var project: Project?
    @NSManaged public var takes: NSSet?

}

// MARK: Generated accessors for takes
extension Section {

    @objc(addTakesObject:)
    @NSManaged public func addToTakes(_ value: Take)

    @objc(removeTakesObject:)
    @NSManaged public func removeFromTakes(_ value: Take)

    @objc(addTakes:)
    @NSManaged public func addToTakes(_ values: NSSet)

    @objc(removeTakes:)
    @NSManaged public func removeFromTakes(_ values: NSSet)

}

extension Section : Identifiable {

}
