//
//  PercentToGrade.swift
//  uGrade
//
//  Created by Ben Fein on 12/6/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//
import Foundation
import SwiftUI
struct PercentToGrade{
    var letters: [[String]] = [[String]]()
    init (letter:[[String]]){
        letters = letter
    }

    func getLetter(grade: String) -> String {
        var L = 0
        var R = letters.count  - 1
        while L <= R {
            let mid = (L + R) / 2
            if(Double(letters[mid][0])! <=  Double(grade)! && Double(letters[mid][1])! >  Double(grade)!){
                return letters[mid][2]
            }
            else if(Double(letters[mid][1])! > Double(grade) ?? -1.00){
                L = mid + 1
            }
            else if (Double(letters[mid][0])! < Double(grade) ?? -1.00){
                R = mid - 1
            }
        }
        return ""
    }
}
