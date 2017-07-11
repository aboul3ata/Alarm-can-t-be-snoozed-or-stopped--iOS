//
//  Alarm+CoreDataProperties.swift
//  Annoying Alarm- Alarm can't be snoozed or stopped!
//
//  Created by Ali Abouelatta on 6/16/17.
//  Copyright © 2017 Ali Abouelatta. All rights reserved.
//

import Foundation
import CoreData


extension Alarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Alarm> {
        return NSFetchRequest<Alarm>(entityName: "Alarm");
    }

    @NSManaged public var duration: Double
    @NSManaged public var time: NSDate?
    @NSManaged public var warning: Bool
    @NSManaged public var annoying: Bool
    @NSManaged public var timeTitle: String

}
