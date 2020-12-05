//
//  ClassView.swift
//  uGrade
//
//  Created by Ben Fein on 6/5/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import Foundation
import CoreData
var ids: UUID = UUID()
var from = false

struct ClassView: View {
    @EnvironmentObject var dis: Pro
    @State var editMode = false
    @State var editMode2 = false
    
    @State var newGrade = false
    var name: String = ""
    var ida: UUID = UUID()
    @ObservedObject var gr: Classes
    //var gra: Grades
    @State var grade: Double = 0.0
    @State var tot: Double = 1.0
    var color = ColorGen()
    // @ObservedObject var productsStore : ProductsStore
    
    @Environment(\.presentationMode) var presentationMode
    
    var fetchRequest: FetchRequest<Grades>
    var grades: FetchedResults<Grades> {(fetchRequest.wrappedValue)}
    
    init(idas: UUID, names:String, grass: Classes) {
        ida = idas
        
        gr = grass
        //gra = gras
        fetchRequest = FetchRequest<Grades>(entity: Grades.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare))], predicate: NSPredicate(format: "asc == %@ ", ida as CVarArg))
        
        ids = idas
        name = names
        ida = idas
        //gra = grasss
        //productsStore = product
    }
    
    
    func setup (){
        ids = ida
        var graderun = 0.0
        var totrun = 0.0
        
        for g in grades {
            if(g.grade != "NULL" && g.total != "NULL"){
                graderun = graderun + (Double(g.grade!) ?? 1.0)
                totrun = totrun + (Double(g.total!) ?? 1.0)
            }
            
        }
        
        grade = graderun
        
        
        //        if(totrun == 0.0){
        //            totrun = 1
        //        }
        if(totrun != 0.0){
            self.gr.setValue("\(graderun)", forKey: "grade")
            self.gr.setValue("\(totrun)", forKey: "total")
        } else{
            self.gr.setValue("NULL", forKey: "grade")
            self.gr.setValue("NULL", forKey: "total")
        }
        if("\(grade)" != gr.grade! || "\(totrun)" != gr.total!  ){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            
            
            
            
            
            do{
                try context.save()
                print("saved")
                
            } catch{
                print("error")
                
            }
        }
    }
    
    var body: some View {
        
        VStack{
            if(UIDevice.current.userInterfaceIdiom == .pad){
                if(gr.classname != nil){
                    
                    VStack{
                        
                        VStack{
                          
                            
                            HStack{
                                Section{
                                    
                                    // Fallback on earlier versions
                                    
                                    if #available(iOS 14.0, *) {
                                        List {
                                            Section{
                                                HStack{
                                                Spacer()
                                                VStack{
                                                    Text("\(Double(gr.grade!) ?? 0.0,specifier: "%.2f") (\((((Double(gr.grade!) ?? 0.00) / (Double(gr.total!) ?? 1.0)) * 100.0),specifier: "%.2f"))%")
                                                        .foregroundColor(.blue)
                                                        .font(.largeTitle)
                                                        .minimumScaleFactor(0.01)
                                                    
                                                    
                                                    
                                                    Text("Grades")
                                                        .foregroundColor(.green)
                                                        .font(.largeTitle)
                                                    
                                                }
                                                Spacer()
                                            }
                                            }
                                            
                                          
                                            
                                            
                                            ForEach(grades, id: \.id){ gradess in
                                                
                                                Section{
                                                    NavigationLink(destination: EditGrade(name: gradess.name!, grade: gradess.grade!, total: gradess.total!, cla: self.gr, gras: gradess)) {
                                                        
                                                        HStack{
                                                            
                                                            Text("\(gradess.name!)")
                                                                .foregroundColor(.white)
                                                                .font(.title)
                                                            Spacer()
                                                            VStack{
                                                                if(gradess.grade != "NULL" && gradess.total != "NULL"){
                                                                    Text("\(gradess.grade!)/\(gradess.total!)")
                                                                        .foregroundColor(.white)
                                                                        
                                                                        .font(.title)
                                                                    Text("Grade")
                                                                        .foregroundColor(.white)
                                                                        .font(.subheadline)
                                                                } else            if(gradess.grade == "NULL" && gradess.total != "NULL"){
                                                                    Text("- /\(gradess.total!)")
                                                                        .foregroundColor(.white)
                                                                        
                                                                        .font(.title)
                                                                    Text("Grade")
                                                                        .foregroundColor(.white)
                                                                        .font(.subheadline)
                                                                    
                                                                } else            if(gradess.grade != "NULL" && gradess.total == "NULL"){
                                                                    Text("\(gradess.grade!)/ -")
                                                                        .foregroundColor(.white)
                                                                        
                                                                        .font(.title)
                                                                    
                                                                    Text("Grade")
                                                                        .foregroundColor(.white)
                                                                        .font(.subheadline)
                                                                    
                                                                }else            if(gradess.grade == "NULL" && gradess.total == "NULL"){
                                                                    Text("- / -")
                                                                        .foregroundColor(.white)
                                                                        
                                                                        .font(.title)
                                                                    Text("Grade")
                                                                        .foregroundColor(.white)
                                                                        .font(.subheadline)
                                                                    
                                                                }
                                                            }
                                                            .onAppear(perform: self.setup)
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                 
                                                    
                                                    
                                                    .listRowBackground(self.color.genColor(grade: ((Double("\(gradess.grade!)")  ?? -100000) / (Double("\(gradess.total!)") ?? 1.0)) * 100.0))
                                                }
                                                
                                            }.onDelete { indexSet in
                                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                let context = appDelegate.persistentContainer.viewContext
                                                let deleteItem = self.grades[indexSet.first!]
                                                context.delete(deleteItem)
                                                do {
                                                    try context.save()
                                                    self.setup()
                                                } catch {
                                                    print(error)
                                                }
                                            }
                                            
                                            
                                        }
                                        
                                        .listStyle(InsetGroupedListStyle())
                                        .environment(\.horizontalSizeClass, .regular)
                                        
                                        .onAppear(perform: setup)

                                        
                                    } else {
                                        // Fallback on earlier versions
                                        List {
                                            
                                            
                                            HStack{
                                                Spacer()
                                                VStack{
                                                    Text("\(Double(gr.grade!) ?? 0.0,specifier: "%.2f") (\((((Double(gr.grade!) ?? 0.00) / (Double(gr.total!) ?? 1.0)) * 100.0),specifier: "%.2f"))%")
                                                        .foregroundColor(.blue)
                                                        .font(.largeTitle)
                                                        .minimumScaleFactor(0.01)
                                                    
                                                    
                                                    
                                                    Text("Grades")
                                                        .foregroundColor(.green)
                                                        .font(.largeTitle)
                                                    
                                                }
                                                Spacer()
                                            }
                                            
                                            
                                            ForEach(grades, id: \.id){ gradess in
                                                
                                                Section{
                                                    NavigationLink(destination: EditGrade(name: gradess.name!, grade: gradess.grade!, total: gradess.total!, cla: self.gr, gras: gradess)) {
                                                        
                                                        HStack{
                                                            
                                                            Text("\(gradess.name!)")
                                                                .foregroundColor(.white)
                                                                .font(.title)
                                                            Spacer()
                                                            VStack{
                                                                if(gradess.grade != "NULL" && gradess.total != "NULL"){
                                                                    Text("\(gradess.grade!)/\(gradess.total!)")
                                                                        .foregroundColor(.white)
                                                                        
                                                                        .font(.title)
                                                                    Text("Grade")
                                                                        .foregroundColor(.white)
                                                                        .font(.subheadline)
                                                                } else            if(gradess.grade == "NULL" && gradess.total != "NULL"){
                                                                    Text("- /\(gradess.total!)")
                                                                        .foregroundColor(.white)
                                                                        
                                                                        .font(.title)
                                                                    Text("Grade")
                                                                        .foregroundColor(.white)
                                                                        .font(.subheadline)
                                                                    
                                                                } else            if(gradess.grade != "NULL" && gradess.total == "NULL"){
                                                                    Text("\(gradess.grade!)/ -")
                                                                        .foregroundColor(.white)
                                                                        
                                                                        .font(.title)
                                                                    
                                                                    Text("Grade")
                                                                        .foregroundColor(.white)
                                                                        .font(.subheadline)
                                                                    
                                                                }else            if(gradess.grade == "NULL" && gradess.total == "NULL"){
                                                                    Text("- / -")
                                                                        .foregroundColor(.white)
                                                                        
                                                                        .font(.title)
                                                                    Text("Grade")
                                                                        .foregroundColor(.white)
                                                                        .font(.subheadline)
                                                                    
                                                                }
                                                            }
                                                            .onAppear(perform: self.setup)
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    .listRowBackground(self.color.genColor(grade: ((Double("\(gradess.grade!)")  ?? -100000) / (Double("\(gradess.total!)") ?? 1.0)) * 100.0))
                                                }
                                                
                                            }.onDelete { indexSet in
                                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                let context = appDelegate.persistentContainer.viewContext
                                                let deleteItem = self.grades[indexSet.first!]
                                                context.delete(deleteItem)
                                                do {
                                                    try context.save()
                                                    self.setup()
                                                } catch {
                                                    print(error)
                                                }
                                            }
                                            
                                            
                                        }
                                        
                                        .onAppear(perform: setup)
                                        
                                        
                                    }
                                }
                                
                                .listStyle(GroupedListStyle())
                                .environment(\.horizontalSizeClass, .regular)
                                .background(Color(UIColor.systemGray6))

                            }

                            .navigationBarItems(trailing:
                                                    
                                                    
                                                    HStack{
                                                        if(gr.isGroup){
                                                            NavigationLink(destination:                                                       EditGroup(name: self.gr.classname!, percent: self.gr.percent!, cla: self.gr)){
                                                                Text("Edit Group")
                                                                    .fontWeight(.semibold)
                                                                
                                                            }
                                                            
                                                            
                                                            
                                                            
                                                        } else{
                                                            
                                                            NavigationLink(destination:                                                       EditClass(name: self.gr.classname!, isWeight: self.gr.isWeight, cla: self.gr)){
                                                                Text("Edit Class")
                                                                    .fontWeight(.semibold)
                                                            }
                                                            
                                                            
                                                        }
                                                        
                                                        
                                                        NavigationLink(destination:NewGrade(cla: self.gr)){
                                                            
                                                            Text("New Grade")
                                                                .fontWeight(.semibold)
                                                                .padding(.leading)                 }
                                                        
                                                        
                                                        
                                                        
                                                    }
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                            )
                        }

                        .navigationBarTitle(name)
                        

                        
                        // .navigationBarTitle(name)

                    }
                    
                } else{
                    Text("")
                }
                

                
                
            }
            else{
                
                VStack{
                    
                    
                    HStack{
                        Section{
                            
                            // Fallback on earlier versions
                            if #available(iOS 14.0, *) {
                                List {
                                    
                                    
                                    HStack{
                                        Spacer()
                                        VStack{
                                            Text("\(Double(gr.grade!) ?? 0.0,specifier: "%.2f") (\((((Double(gr.grade!) ?? 0.00) / (Double(gr.total!) ?? 1.0)) * 100.0),specifier: "%.2f"))%")
                                                .foregroundColor(.blue)
                                                .font(.largeTitle)
                                                .minimumScaleFactor(0.01)
                                            
                                            
                                            
                                            Text("Grades")
                                                .foregroundColor(.green)
                                                .font(.largeTitle)
                                            
                                        }
                                        Spacer()
                                    }
                                    
                                    
                                    ForEach(grades, id: \.id){ gradess in
                                        
                                        Section{
                                            NavigationLink(destination: EditGrade(name: gradess.name!, grade: gradess.grade!, total: gradess.total!, cla: self.gr, gras: gradess)) {
                                                
                                                HStack{
                                                    
                                                    Text("\(gradess.name!)")
                                                        .foregroundColor(.white)
                                                        .font(.title)
                                                    Spacer()
                                                    VStack{
                                                        if(gradess.grade != "NULL" && gradess.total != "NULL"){
                                                            Text("\(gradess.grade!)/\(gradess.total!)")
                                                                .foregroundColor(.white)
                                                                
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                        } else            if(gradess.grade == "NULL" && gradess.total != "NULL"){
                                                            Text("- /\(gradess.total!)")
                                                                .foregroundColor(.white)
                                                                
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                            
                                                        } else            if(gradess.grade != "NULL" && gradess.total == "NULL"){
                                                            Text("\(gradess.grade!)/ -")
                                                                .foregroundColor(.white)
                                                                
                                                                .font(.title)
                                                            
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                            
                                                        }else            if(gradess.grade == "NULL" && gradess.total == "NULL"){
                                                            Text("- / -")
                                                                .foregroundColor(.white)
                                                                
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                            
                                                        }
                                                    }
                                                    .onAppear(perform: self.setup)

                                                    }
                                            }
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            .listRowBackground(self.color.genColor(grade: ((Double("\(gradess.grade!)")  ?? -100000) / (Double("\(gradess.total!)") ?? 1.0)) * 100.0))
                                            .listRowInsets(.init(top: 15, leading: 20, bottom: 15, trailing: 20))
                                        }
                                        
                                    }             .onDelete { indexSet in
                                       
                                        let deleteItem = self.grades[indexSet.first!]
                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                        let context = appDelegate.persistentContainer.viewContext

                                        context.perform {
                                                
                                                do {
                                                    context.delete(deleteItem)
                                                    
                                                    // Saves in private context
                                                    try context.save()
                                                } catch {
                                                    fatalError("Failure to save context: \(error)")
                                                }
                                            }
                                    }
                                    
                                    
                                    
                                }
                                .onAppear(perform: setup)
                                
                                .listStyle(InsetGroupedListStyle())
                                .environment(\.horizontalSizeClass, .regular)
                            } else {
                                // Fallback on earlier versions
                                List {
                                    
                                    
                                    HStack{
                                        Spacer()
                                        VStack{
                                            Text("\(Double(gr.grade!) ?? 0.0,specifier: "%.2f") (\((((Double(gr.grade!) ?? 0.00) / (Double(gr.total!) ?? 1.0)) * 100.0),specifier: "%.2f"))%")
                                                .foregroundColor(.blue)
                                                .font(.largeTitle)
                                                .minimumScaleFactor(0.01)
                                            
                                            
                                            
                                            Text("Grades")
                                                .foregroundColor(.green)
                                                .font(.largeTitle)
                                            
                                        }
                                        Spacer()
                                    }
                                    
                                    
                                    ForEach(grades, id: \.id){ gradess in
                                        
                                        Section{
                                            NavigationLink(destination: EditGrade(name: gradess.name!, grade: gradess.grade!, total: gradess.total!, cla: self.gr, gras: gradess)) {
                                                
                                                HStack{
                                                    
                                                    Text("\(gradess.name!)")
                                                        .foregroundColor(.white)
                                                        .font(.title)
                                                    Spacer()
                                                    VStack{
                                                        if(gradess.grade != "NULL" && gradess.total != "NULL"){
                                                            Text("\(gradess.grade!)/\(gradess.total!)")
                                                                .foregroundColor(.white)
                                                                
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                        } else            if(gradess.grade == "NULL" && gradess.total != "NULL"){
                                                            Text("- /\(gradess.total!)")
                                                                .foregroundColor(.white)
                                                                
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                            
                                                        } else            if(gradess.grade != "NULL" && gradess.total == "NULL"){
                                                            Text("\(gradess.grade!)/ -")
                                                                .foregroundColor(.white)
                                                                
                                                                .font(.title)
                                                            
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                            
                                                        }else            if(gradess.grade == "NULL" && gradess.total == "NULL"){
                                                            Text("- / -")
                                                                .foregroundColor(.white)
                                                                
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                            
                                                        }
                                                    }
                                                    .onAppear(perform: self.setup)
                                                }
                                            }
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            .listRowBackground(self.color.genColor(grade: ((Double("\(gradess.grade!)")  ?? -100000) / (Double("\(gradess.total!)") ?? 1.0)) * 100.0))
                                            .listRowInsets(.init(top: 15, leading: 20, bottom: 15, trailing: 20))
                                        }
                                        
                                    }.onDelete { indexSet in
                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                        let context = appDelegate.persistentContainer.viewContext
                                        let deleteItem = self.grades[indexSet.first!]
                                        context.delete(deleteItem)
                                        do {
                                            try context.save()
                                            self.setup()
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    
                                    
                                }
                                .onAppear(perform: setup)
                                
                               
                            }
                            
                        }
                        .listStyle(GroupedListStyle())
                        .environment(\.horizontalSizeClass, .regular)

                        
                    }
                    
                }
                .navigationBarItems(trailing:
                                        
                                        
                                        HStack{
                                            Section{
                                                if(gr.isGroup){
                                                    
                                                    Button(action: {self.editMode.toggle()}) {
                                                        
                                                        Text("Edit Group")
                                                            .fontWeight(.semibold)
                                                            .padding(.leading)
                                                        
                                                    }  .sheet(isPresented: $editMode){
                                                        EditGroup(name: self.gr.classname!, percent: self.gr.percent!, cla: self.gr)
                                                    }
                                                    
                                                    
                                                    
                                                } else{
                                                    
                                                    Button(action: {self.editMode.toggle()}) {
                                                        
                                                        Text("Edit Class")
                                                            .fontWeight(.semibold)
                                                            
                                                            .sheet(isPresented: $editMode){
                                                                EditClass(name: self.gr.classname!, isWeight: self.gr.isWeight,currentTerm: self.gr.term!, cla: self.gr)
                                                            }
                                                    }
                                                    
                                                }
                                            }
                                            Button(action: {self.newGrade.toggle()}) {
                                                
                                                Text("New Grade")
                                                    .fontWeight(.semibold)
                                                    .padding(.leading)      
                                                    .sheet(isPresented: $newGrade){
                                                        NewGrade(cla: self.gr)
                                                    }
                                            }
                                            
                                            
                                            
                                        }
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                )
                .navigationBarTitle(name)
            }
            
            
            
            
            
            
            
            

            
            
            
        }

    }
}




//struct ClassView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassView(name: "CS 242")
//    }
//}
