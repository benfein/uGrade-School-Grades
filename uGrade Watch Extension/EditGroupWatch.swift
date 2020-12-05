//
//  EditGroupWatch.swift
//  uGrade Watch Extension
//
//  Created by Ben Fein on 6/20/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import CoreData
struct EditGroupWatch: View {
    @State var name: String = ""
    @State var percent: String = ""
    
    
    var cla: Classes
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    
    
    
    var body: some View {
        Form{
            Section{
                TextField("Class Name", text: $name)
            }
            Section{
                TextField("Total Weight", text: $percent)
            }
            
            
            
            HStack{
                Spacer()
                Button("Save") {
                    
                    
                    
                    self.cla.setValue(self.name, forKey: "classname")
                    self.cla.setValue(self.percent, forKey: "percent")
                    
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
        }
        
        
    }
}
//struct EditGrade_Previews: PreviewProvider {
//    static var previews: some View {
//        EditGrade()
//    }
//}
