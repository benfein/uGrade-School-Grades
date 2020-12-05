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
    
    @State var cla: Classes
    //@State var curr: Int
    //@State var currTotal: Int
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    func setup(){
    }
    var body: some View {
        
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
                            self.grade = "NULL"
                        }
                        if(self.total == ""){
                            self.total = "NULL"
                        }
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context = appDelegate.persistentContainer.viewContext
                        let entity = NSEntityDescription.entity(forEntityName: "Grades", in: context)
                        
                        let contact = NSManagedObject(entity: entity!, insertInto: context)
                        contact.setValue(self.name, forKey: "name")
                        if(self.grade == ""){
                            contact.setValue("NULL", forKey: "grade")
                        } else{
                            contact.setValue(self.grade, forKey: "grade")
                        }
                        if(self.total == ""){
                            contact.setValue("NULL", forKey: "total")
                            
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
    
    
}



