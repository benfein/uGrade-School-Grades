//
//  NewGrade.swift
//  uGrade
//
//  Created by Ben Fein on 6/6/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//
import SwiftUI
import CoreData
struct NewGrade: View {
    @State var name: String = ""
    @State var grade: String = ""
    @State var total: String = ""
    @State var f = false
    @State var n = "NULL"
    @State var cla: Classes
    //@State var curr: Int
    //@State var currTotal: Int
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    func setup(){
    }
    var body: some View {
        NavigationView{
        Form{
            Section{
                TextField("Graded Item Name", text: $name)
            }.onAppear(perform: setup)
            Section{
                TextField("Grade", text: $grade)
                    .keyboardType(.decimalPad)
                TextField("Total Points", text: $total)
                    .keyboardType(.decimalPad)
            }
            Section{
                HStack{
                    Spacer()
                    Button("Add Grade") {
                        if(self.grade == ""){
                            self.grade = n
                        }
                        if(self.total == ""){
                            self.total = n
                        }
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context = appDelegate.persistentContainer.viewContext
                        let entity = NSEntityDescription.entity(forEntityName: "Grades", in: context)
                        let contact = NSManagedObject(entity: entity!, insertInto: context)
                        contact.setValue(self.name, forKey: "name")
                        if(self.grade == ""){
                            contact.setValue(n, forKey: "grade")
                        } else{
                            contact.setValue(self.grade, forKey: "grade")
                        }
                        if(self.total == ""){
                            contact.setValue(n, forKey: "total")
                        } else{
                            contact.setValue(self.total, forKey: "total")
                        }
                        contact.setValue(self.total, forKey: "total")
                        contact.setValue(UUID(), forKey: "id")
                        contact.setValue(self.cla.id, forKey: "asc")
                        do{
                            try context.save()
                            self.mode.wrappedValue.dismiss()
                        } catch {
                            print("Failed saving")
                        }
                    }
                    Spacer()
                }
            }
            .onAppear(perform: setup)
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
        }
        .navigationBarTitle("New Grade")

    }
        .navigationViewStyle(StackNavigationViewStyle())

    }
}
struct NewGrade_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let classes = Classes.init(context: context)
        classes.id = UUID()
        return NewGrade(cla: classes).environmentObject(Pro()).environment(\.managedObjectContext, context).environmentObject(Model(isPortrait: UIScreen.main.bounds.width < UIScreen.main.bounds.height))
    }
}
