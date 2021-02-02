//
//  NewClas.swift
//  uGrade
//
//  Created by Ben Fein on 6/5/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//
import SwiftUI
import CoreData
import Combine
struct NewClass: View {
    @State var name = ""
    @State var isWeight: Bool = false
    @State var grade = "NULL"
    @State var n = "NULL"
    @State var f = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var term = "No Term"
    var sem = [String]()
    func setup(){
    }
    init() {
        let currentDate = Date()
        let format = DateFormatter()
        format.setLocalizedDateFormatFromTemplate("YYYY")
        let currentYearInString = format.string(from: currentDate)
        sem.append("No Term")
        for i in Int(currentYearInString)! - 4 ... Int(currentYearInString)! + 4 {
            sem.append("Spring \(i)")
            sem.append("Summer \(i)")
            sem.append("Fall \(i)")
        }
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView{
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
                Picker(selection: $term, label: Text("Semester")) {
                    ForEach (sem, id: \.self) { i in
                        Text(i).tag(i)
                    }
                }
            }
            Section{
                HStack{
                    Spacer()
                    Button("Add Course") {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context = appDelegate.persistentContainer.viewContext
                        let entity = NSEntityDescription.entity(forEntityName: "Classes", in: context)
                        let contact = NSManagedObject(entity: entity!, insertInto: context)
                        contact.setValue(self.name, forKey: "classname")
                        contact.setValue(self.grade, forKey: "grade")
                        contact.setValue(n, forKey: "total")
                        contact.setValue(self.isWeight, forKey: "isWeight")
                        contact.setValue(f, forKey: "isGroup")
                        contact.setValue(self.term, forKey: "term")
                        contact.setValue(UUID(), forKey: "id")
                        do{
                            try context.save()
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
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Not Now")
                }
                Spacer()
            }
        }
        //.listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .onAppear(perform: setup)
        .navigationBarBackButtonHidden(true)
        }
        .navigationBarTitle("New Course")

        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
struct NewClass_Previews: PreviewProvider {
    static var previews: some View {
        let contexts = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return NewClass().environment(\.managedObjectContext, contexts)
    }
}
