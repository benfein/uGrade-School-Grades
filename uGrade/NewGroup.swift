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
    @State var name: String = ""
    @State var percent:String = ""
    @State var cla: Classes
    @State var n = "NULL"
    @State var t = true
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
                    Button("Save Group")
                    {
                        let context = appDelegate.persistentContainer.viewContext
                        let entity = Classes.entity()
                        let contact = NSManagedObject(entity: entity, insertInto: context)
                        contact.setValue(
                            self.name, forKey: "classname"
                        )
                        contact.setValue(t, forKey: "isWeight")
                        contact.setValue(t,forKey: "isGroup")
                        contact.setValue(self.percent, forKey: "percent")
                        contact.setValue(n, forKey: "total")
                        contact.setValue(n, forKey: "grade")
                        contact.setValue(cla.id, forKey: "asc")
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
struct NewGroup_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let classes = Classes.init(context: context)
        classes.id = UUID()
        return NewGroup(cla: classes).environmentObject(Pro()).environment(\.managedObjectContext, context).environmentObject(Model(isPortrait: UIScreen.main.bounds.width < UIScreen.main.bounds.height))
    }
}
