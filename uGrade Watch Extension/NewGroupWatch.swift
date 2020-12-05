//
//  NewGroupWatch.swift
//  uGrade Watch Extension
//
//  Created by Ben Fein on 6/20/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import CoreData
struct NewGroupWatch: View {
    var context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    
    @State var name = ""
    @State var percent = ""
    var cla: Classes
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        Form{
            Section{
                TextField("Category Name", text: $name)
            }
            Section{
                TextField("Total Weight", text: $percent)
            }
            
            
            Section{
                HStack{
                    Spacer()
                    Button("Save Category") {
                        
                        let entity = NSEntityDescription.entity(forEntityName: "Classes", in: self.context)
                        
                        let contact = NSManagedObject(entity: entity!, insertInto: self.context)
                        contact.setValue(self.name, forKey: "classname")
                        contact.setValue(true, forKey: "isWeight")
                        contact.setValue(true, forKey: "isGroup")
                        
                        contact.setValue(self.percent, forKey: "percent")
                        contact.setValue("1", forKey: "total")
                        contact.setValue("0", forKey: "grade")
                        
                        contact.setValue(self.cla.id, forKey: "asc")
                        contact.setValue(UUID(), forKey: "id")
                        
                        do{
                            try self.context.save()
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
