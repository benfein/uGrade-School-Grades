//
//  ClassView.swift
//  uGrade
//
//  Created by Ben Fein on 6/5/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//
import SwiftUI
import Foundation
import CoreData

struct GradesView: View {
    var currentName: String = ""
    var currentID: UUID = UUID()
    @ObservedObject var currentClass: Classes
    init(currentID: UUID, currentName:String, currentClass: Classes) {
        self.currentID = currentID
        self.currentClass = currentClass
        self.currentName = currentName
    }
    var body: some View {
        VStack{
            if(UIDevice.current.userInterfaceIdiom == .pad){
                ReuseGradesView(currentID: currentClass.id!, currentName: currentName, currentClass: currentClass)
            }
            else{
                ReuseGradesView(currentID: currentClass.id ?? UUID(), currentName: currentName, currentClass: currentClass)            }
            }
        }
    }
struct ClassView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let cl = Classes.init(context: context)
        cl.id = UUID()
        cl.grade = "0.00"
        cl.total = "0.00"
        return GradesView(currentID: UUID(), currentName: "CS 242", currentClass: cl)
    }
}
