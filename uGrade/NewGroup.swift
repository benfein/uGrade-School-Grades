//
//  NewGroup.swift
//  uGrade
//
//  Created by Ben Fein on 6/7/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import CoreData
struct NewGroup: View {
    @State var name = ""
    @State var percent = ""
    var cla: Classes
    @Environment(\.presentationMode) var presentationMode
    
    func setup(){
        
    }
    var body: some View {
        NavigationView{
        Form{
            Section{
                TextField("Weighted Group Name", text: $name)
            }
            Section{
                TextField("Total Weight", text: $percent)
                    .keyboardType(.numberPad)
            }
            
            
            Section{
                HStack{
                    Spacer()
                    Button("Save Group") {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context = appDelegate.persistentContainer.viewContext
                        let entity = NSEntityDescription.entity(forEntityName: "Classes", in: context)
                        
                        let contact = NSManagedObject(entity: entity!, insertInto: context)
                        contact.setValue(self.name, forKey: "classname")
                        contact.setValue(true, forKey: "isWeight")
                        contact.setValue(true, forKey: "isGroup")
                        
                        contact.setValue(self.percent, forKey: "percent")
                        contact.setValue("NULL", forKey: "total")
                        contact.setValue("NULL", forKey: "grade")
                        
                        contact.setValue(self.cla.id, forKey: "asc")
                        contact.setValue(UUID(), forKey: "id")
                        
                        do{
                            try context.save()
                            self.presentationMode.wrappedValue.dismiss()
                            
                        } catch {
                            print("Failed saving")
                        }
                    }
                    
                    Spacer()
                }
            }
            Section{
            HStack{
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Text("Not Now")
                }
                Spacer()
            }
            }
        }
        .onAppear(perform: setup)
        
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("New Weighted Group")
        }
    }
    
}
