//
//  Product+CoreDataClass.swift
//  MDB2_APP
//
//  Created by Hannah on 4/6/18.
//  Copyright © 2018 Hannah. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Product)
public class Product: NSManagedObject {
    let id: Int32
    let name: String
    let quantity: Int32
}
