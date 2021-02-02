//
//  GradeNeeded.swift
//  uGrade
//
//  Created by Ben Fein on 12/8/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//
import Foundation
import SwiftUI
import CoreData
class GradeNeeded{
func findWhatIsNeeded(gradeWanted: Double, classIn: Classes, currentWeigh: Classes, allWeights: FetchedResults<Classes>) -> Double{
    let grade = Double(classIn.grade!) ?? 0.00
    var currentWeight = 75.0
    var finalWeight = 25.0
    for i in allWeights{
        if(currentWeigh.id != i.id && i.grade != "0.00" && i.grade != "NULL"){
            currentWeight = currentWeight + (Double(i.percent!) ?? 0.00)
        } else{
            finalWeight = Double(i.percent!) ?? 0.00
        }
    }
    finalWeight = finalWeight / 100.0
    print((gradeWanted - grade * (1 - finalWeight)) / finalWeight)
    return (gradeWanted - grade * (1 - finalWeight)) / finalWeight
}
}
