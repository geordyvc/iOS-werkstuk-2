//
//  OpmerkelijkeBomen+CoreDataProperties.swift
//  werkstuk2Ios
//
//  Created by Admin on 5/06/17.
//  Copyright © 2017 Geordy. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension OpmerkelijkeBomen {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OpmerkelijkeBomen> {
        return NSFetchRequest<OpmerkelijkeBomen>(entityName: "OpmerkelijkeBomen");
    }

    @NSManaged public var nhits: Int16
    @NSManaged public var parameters: NSObject?
    @NSManaged public var records: NSObject?

}
