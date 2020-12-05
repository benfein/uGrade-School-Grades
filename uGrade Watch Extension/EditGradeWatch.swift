//
//  EditGradeWatch.swift
//  uGrade Watch Extension
//
//  Created by Ben Fein on 6/20/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import CoreData
struct EditGradeWatch: View {
    @State var name: String = ""
    @State var grade: String = ""
    @State var total: String = ""
    var context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    
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
        let context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
        
        
        
        
        
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
                    TextField("Total Points", text: $total)
                    
                }
                HStack{
                    Spacer()
                    Button("Save") {
                        
                        let context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
                        if(self.grade == ""){
                            self.gras.setValue("NULL", forKey: "grade")
                        } else{
                            self.gras.setValue(self.grade, forKey: "grade")
                        }
                        if(self.total == ""){
                            self.gras.setValue("NULL", forKey: "total")
                            
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
                
                
            }
            .onAppear(perform: setup)
            
        }
        
    }
    
    
}
//struct EditGrade_Previews: PreviewProvider {
//    static var previews: some View {
//        EditGrade()
//    }
//}
