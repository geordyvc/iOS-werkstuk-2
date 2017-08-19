//
//  Parameter+CoreDataProperties.swift
//  werkstuk2Ios
//
//  Created by Admin on 5/06/17.
//  Copyright © 2017 Geordy. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Parameter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Parameter> {
        return NSFetchRequest<Parameter>(entityName: "Parameter");
    }

    @NSManaged public var dataset: String?
    @NSManaged public var timezone: String?
    @NSManaged public var rows: Int16
    @NSManaged public var format: String?
    @NSManaged public var parameters: OpmerkelijkeBomen?

}
