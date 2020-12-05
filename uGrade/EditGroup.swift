//
//  EditGroup.swift
//  uGrade
//
//  Created by Ben Fein on 6/8/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import CoreData
struct EditGroup: View {
    @State var name: String = ""
    @State var percent: String = ""
    
    
    @State var cla: Classes
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
    func setup(){
        
    }
    var body: some View {
        NavigationView{
        Form{
            Section{
                TextField("Class Name", text: $name)
            }
            Section{
                TextField("Total Weight", text: $percent)
                    .keyboardType(.numberPad)
            }
            
            
            Section{
                HStack{
                    Spacer()
                    Button("Save") {
                        
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context = appDelegate.persistentContainer.viewContext
                        self.cla.setValue(self.name, forKey: "classname")
                        self.cla.setValue(self.percent, forKey: "percent")
                        
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
        }
        .navigationBarTitle("Edit Weighted Group")
        }
        
        
    }
}
//struct EditGrade_Previews: PreviewProvider {
//    static var previews: some View {
//        EditGrade()
//    }
//}

