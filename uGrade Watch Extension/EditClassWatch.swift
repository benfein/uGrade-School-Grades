//
//  EditClassWatch.swift
//  uGrade Watch Extension
//
//  Created by Ben Fein on 6/20/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import CoreData
struct EditClassWatch: View {
    @State var name: String = ""
    @State var currentTerm: String = ""

    @State var isWeight: Bool = false
    
    var context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    @State var sem = [String]()
    var cla: Classes
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    func setup(){
        let currentDate = Date()
        let format = DateFormatter()
        format.setLocalizedDateFormatFromTemplate("YYYY")
        let currentYearInString = format.string(from: currentDate)
        for i in Int(currentYearInString)! - 4 ... Int(currentYearInString)! + 4 {
            sem.append("Spring \(i)")
            sem.append("Summer \(i)")
            sem.append("Fall \(i)")
        }
    }
    var body: some View {
        Form{
            Section{
                TextField("Class Name", text: $name)
            }
            
            
            Section{
                Picker(selection: $currentTerm, label: Text("Semester")) {
                
                    ForEach (sem, id: \.self) { i in
                        Text(i).tag(i)
                    }
                }
            }
            
            
            HStack{
                Spacer()
                Button("Save") {
                    
                    
                    
                    self.cla.setValue(self.isWeight, forKey: "isWeight")
                    self.cla.setValue(self.name, forKey: "classname")
                    self.cla.setValue(self.currentTerm, forKey: "term")

                    do{
                        try self.context.save()
                        print("saved")
                        self.mode.wrappedValue.dismiss()
                        
                    } catch{
                        print("error")
                        
                    }
                }
                Spacer()
                
            }
        }.onAppear(perform: setup)
        
    }
}
//struct EditGrade_Previews: PreviewProvider {
//    static var previews: some View {
//        EditGrade()
//    }
//}

