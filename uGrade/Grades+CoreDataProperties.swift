//
//  Grades+CoreDataProperties.swift
//  uGrade
//
//  Created by Ben Fein on 8/15/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//
//

import Foundation
import CoreData


extension Grades {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grades> {
        return NSFetchRequest<Grades>(entityName: "Grades")
    }

    @NSManaged public var asc: UUID?
    @NSManaged public var grade: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isWeight: Bool
    @NSManaged public var name: String?
    @NSManaged public var total: String?

}
