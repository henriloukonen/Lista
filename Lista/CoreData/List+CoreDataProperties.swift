//
//  List+CoreDataProperties.swift
//  Lista
//
//  Created by Henri Loukonen on 18/07/2019.
//  Copyright © 2019 Henri Loukonen. All rights reserved.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var category: String
    @NSManaged public var dateAdded: NSDate
    @NSManaged public var item: String
    @NSManaged public var amount: Int16

}
