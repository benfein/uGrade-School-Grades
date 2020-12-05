//
//  NewGradeWatch.swift
//  uGrade Watch Extension
//
//  Created by Ben Fein on 6/20/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import CoreData
struct NewGradeWatch: View {
    @State var name: String = ""
    @State var grade: String = ""
    @State var total: String = ""
    
    @State var cla: Classes
    //@State var curr: Int
    //@State var currTotal: Int
    var context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
    var body: some View {
        Form{
            
            Section{
                TextField("Graded Item Name", text: $name)
            }
            Section{
                
                TextField("Grade", text: $grade)
                TextField("Total Points", text: $total)
                
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
                        
                        let context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
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
                            print("SUCCESS")
                            
                            self.mode.wrappedValue.dismiss()
                            
                        } catch {
                            print("Failed saving")
                        }
                    }
                    
                    Spacer()
                    
                    
                }
            }
            
            
            
        }
        
    }
    
    
}





//struct NewGrade_Previews: PreviewProvider {
//    static var previews: some View {
//        NewGrade(name: "65", cla: Classes(), curr: 100, currTotal: 100)
//    }
//}
