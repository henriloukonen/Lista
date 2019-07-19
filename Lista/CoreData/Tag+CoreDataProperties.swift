//
//  Tag+CoreDataProperties.swift
//  Lista
//
//  Created by Henri Loukonen on 19/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var color: String?
    @NSManaged public var items: NSSet

}

// MARK: Generated accessors for items
extension Tag {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: List)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: List)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
