//
//  EditClass.swift
//  uGrade
//
//  Created by Ben Fein on 6/8/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import CoreData
struct EditClass: View {
    @State var name: String = ""
    @State var isWeight: Bool = false
    @State var currentTerm: String = ""

    @State var sem = [String]()
    
    var cla: Classes
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    func setup(){
        let currentDate = Date()
        let format = DateFormatter()
        format.setLocalizedDateFormatFromTemplate("YYYY")
        let currentYearInString = format.string(from: currentDate)
        for i in Int(currentYearInString)! ... Int(currentYearInString)! + 4 {
            sem.append("Spring \(i)")
            sem.append("Summer \(i)")
            sem.append("Fall \(i)")
        }
    }
    
    var body: some View {
        NavigationView{
        Form{
            Section{
                TextField("Class Name", text: $name)
            }
            
            Section{
                Picker(selection: $currentTerm, label: Text("Semester")) {
                    Text("No Term").tag("No Term")
                    ForEach (sem, id: \.self) { i in
                        Text(i).tag(i)
                    }
                }
            }
            
            
            
            
            HStack{
                Spacer()
                Button("Save") {
                    
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    self.cla.setValue(self.isWeight, forKey: "isWeight")
                    self.cla.setValue(self.name, forKey: "classname")
                    self.cla.setValue(self.currentTerm, forKey: "term")

                    do{
                        try context.save()
                        print("saved")
                        self.mode.wrappedValue.dismiss()
                        
                    } catch{
                        print("error")
                        
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
        }.onAppear(perform: setup)
        
        
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Edit Course")
        }
    }
}
