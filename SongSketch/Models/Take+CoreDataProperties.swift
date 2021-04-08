//
//  Take+CoreDataProperties.swift
//  SongSketch
//
//  Created by Samuel Garry on 4/7/21.
//
//

import Foundation
import CoreData


extension Take {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Take> {
        return NSFetchRequest<Take>(entityName: "Take")
    }

    @NSManaged public var audioFilePath: String?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var numOfTakes: Int64
    @NSManaged public var section: Section?

}

extension Take : Identifiable {

}
