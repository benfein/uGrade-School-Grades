//
//  Classes+CoreDataProperties.swift
//  uGrade
//
//  Created by Ben Fein on 8/15/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//
//

import Foundation
import CoreData


extension Classes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Classes> {
        return NSFetchRequest<Classes>(entityName: "Classes")
    }

    @NSManaged public var asc: UUID?
    @NSManaged public var classname: String?
    @NSManaged public var grade: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isGroup: Bool
    @NSManaged public var isWeight: Bool
    @NSManaged public var percent: String?
    @NSManaged public var total: String?
    @NSManaged public var totalGrade: String?

}
