//
//  NewClassWatch.swift
//  uGrade
//
//  Created by Ben Fein on 6/20/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import CoreData
import Combine
struct NewClassWatch: View {
    var sem = [String]()
    @State var name = ""
    @State var currentTerm = "No Term"
    @State var isWeight = false
    var context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    var managedObjectContext = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    init() {
        let currentDate = Date()
        let format = DateFormatter()
        format.setLocalizedDateFormatFromTemplate("YYYY")
        let currentYearInString = format.string(from: currentDate)
        sem.append("No Term")
        for i in Int(currentYearInString)! ... Int(currentYearInString)! + 4 {
            sem.append("Spring \(i)")
            sem.append("Summer \(i)")
            sem.append("Fall \(i)")
        }
    }
    var body: some View {
        VStack{
            
        Form{
            Section{
                TextField("Class Name", text: $name)
            }
            Section{
                Toggle(isOn: $isWeight) {
                    Text("Weighted Course?")
                }
            }
            Section{
                Picker(selection: $currentTerm, label: Text("Semester")) {
                  
                    ForEach (sem, id: \.self) { i in
                        Text(i).tag(i)
                    }
                }
            }
            
            Section{
                HStack{
                    Spacer()
                    Button("Add Course") {
                        
                        
                        let entity = NSEntityDescription.entity(forEntityName: "Classes", in: self.context)
                        
                        let contact = NSManagedObject(entity: entity!, insertInto: self.context)
                        contact.setValue(self.name, forKey: "classname")
                        contact.setValue("0", forKey: "grade")
                        contact.setValue("1", forKey: "total")
                        contact.setValue(self.isWeight, forKey: "isWeight")
                        contact.setValue(false, forKey: "isGroup")
                        contact.setValue(self.currentTerm, forKey: "term")

                        contact.setValue(UUID(), forKey: "id")
                        
                        do{
                            try self.context.save()
                            self.mode.wrappedValue.dismiss()
                            
                            
                        } catch {
                            print(error)
                        }
                    }
                    
                    
                    
                    Spacer()
                    
                    
                }
            }
            Section{
                HStack{
                    Spacer()
                    Button("Cancel") {
                        self.mode.wrappedValue.dismiss()
                        
                    }
                    Spacer()
                }
            }
            
            
        }
        
        
        
        //.listStyle(GroupedListStyle())
        // .onAppear(perform: setup)
        .navigationBarTitle("New Course")
            
        }
    }
    
}

//struct NewClassWatch_Previews: PreviewProvider {
//    static var previews: some View {
//        NewClassWatch()
//    }
//}
