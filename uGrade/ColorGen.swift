//
//  ColorGen.swift
//  uGrade
//
//  Created by Ben Fein on 6/9/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//
import Foundation
import SwiftUI
class ColorGen {
    func genColor(grade: Double) -> Color{
        if(grade >= 90.0){
            return Color(red: 0.0, green: 0.6, blue: 0.0)
        }
        else if(grade < 89.99 && grade >= 80.00){
            return Color.green
        }
        else if(grade < 79.99 && grade >= 70.00){
            return Color.yellow
        } else if(grade < 69.99 && grade >= 60.00){
            return Color.orange
        }
        else if(grade < 59.99 && grade >= 0){
                return Color.red
        } else {
            return Color.gray
        }
    }
}
