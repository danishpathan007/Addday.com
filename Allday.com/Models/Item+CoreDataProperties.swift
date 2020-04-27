//
//  Item+CoreDataProperties.swift
//  Allday.com
//
//  Created by Danish Khan on 28/04/20.
//  Copyright © 2020 Danish Khan. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var done: Bool
    @NSManaged public var title: String?
    @NSManaged public var parentRelation: CategoryList?

}
