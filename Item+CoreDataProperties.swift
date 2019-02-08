//
//  Item+CoreDataProperties.swift
//  CD-Grocery-images
//
//  Created by Admin on 5/2/2562 BE.
//  Copyright © 2562 Saiwarun.Y. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?

}
