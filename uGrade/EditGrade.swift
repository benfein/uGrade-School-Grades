//
//  EditGrade.swift
//  uGrade
//
//  Created by Ben Fein on 6/6/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//
import SwiftUI
import CoreData
struct EditGrade: View {
    @State var name: String = ""
    @State var grade: String = ""
    @State var total: String = ""
    @State var n = "NULL"
    @State var cla: Classes
    var gras: Grades
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    func setup(){
        if(grade == "NULL"){
            grade = ""
        }
        if(total == "NULL"){
            total = ""
        }
    }
    // @State var curr: Int
    //@State var currTotal: Int
    func updateContact(classes: Classes) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do{
            try context.save()
            print("saved")
            self.mode.wrappedValue.dismiss()
        } catch{
            print("error")
        }
    }
    var body: some View {

        VStack{
            Form{
                Section{
                    TextField("Graded Item Name", text: $name)
                }
                Section{
                        TextField("Grade", text: $grade)
                            .keyboardType(.decimalPad)
                        TextField("Total Points", text: $total)
                            .keyboardType(.decimalPad)
                }
                HStack{
                    Spacer()
                    Button("Save") {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context = appDelegate.persistentContainer.viewContext
                        if(self.grade == ""){
                            self.gras.setValue(n, forKey: "grade")
                        } else{
                            self.gras.setValue(self.grade, forKey: "grade")
                        }
                        if(self.total == ""){
                            self.gras.setValue(n, forKey: "total")
                        } else{
                            self.gras.setValue(self.total, forKey: "total")
                        }
                        self.gras.setValue(self.name, forKey: "name")
                        do{
                            try context.save()
                            print("saved")
                            self.updateContact(classes: self.cla)
                            //self.mode.wrappedValue.dismiss()
                        } catch{
                            print(error)
                        }
                    }
                    Spacer()
                }
                Section{
                HStack{
                    Spacer()
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }) {
                        Text("Not Now")
                    }
                    Spacer()
                }
            }
            .onAppear(perform: setup)
            }
            .navigationBarTitle("Edit Grade")
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        }
    }

struct EditGrade_Previews: PreviewProvider {
    static var previews: some View {
        let classes = Classes.init()
        let grade = Grades.init()
        return EditGrade(cla: classes, gras: grade)
    }
}
