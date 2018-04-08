//
//  Product+CoreDataProperties.swift
//  MDB2_APP
//
//  Created by Hannah on 4/6/18.
//  Copyright © 2018 Hannah. All rights reserved.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var id: String
    @NSManaged public var price: NSObject?
    @NSManaged public var name: NSObject?

}
