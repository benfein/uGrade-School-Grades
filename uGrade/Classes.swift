//
//  Classes.swift
//  uGrade
//
//  Created by Ben Fein on 6/5/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

extension Classes {
    static func getListItemFetchRequest() -> NSFetchRequest<Classes>{
        let request: NSFetchRequest<Classes> = Classes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "classname", ascending: true)]
        
        return request
    }
}
extension Grades {
    static func getListItemFetchRequest() -> NSFetchRequest<Grades>{
        let request: NSFetchRequest<Grades> = Grades.fetchRequest()
        request.predicate = NSPredicate(format: "asc == %@", idcode as CVarArg)
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return request
    }
}

