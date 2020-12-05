//
//  GroupList.swift
//  uGrade
//
//  Created by Ben Fein on 6/7/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import CoreData
struct GroupList: View {
    var name: String = ""
    var ida: UUID
    @EnvironmentObject var dis: Pro
    
    @ObservedObject var gr: Classes
    //@ObservedObject var productsStore : ProductsStore
    @State var grade: Int = 0
    @State var tot: Int = 1
    @Environment(\.presentationMode) var presentationMode
    var fetchRequests: FetchRequest<Grades>
    var grad: FetchedResults<Grades> {(fetchRequests.wrappedValue)}
    var fetchRequest: FetchRequest<Classes>
    var grades: FetchedResults<Classes> {(fetchRequest.wrappedValue)}
    init(idas: UUID, names:String, grass: Classes, product: ProductsStore) {
        ida = idas
        //productsStore = product
        fetchRequest = FetchRequest<Classes>(entity: Classes.entity(), sortDescriptors: [NSSortDescriptor(key: "classname", ascending: true, selector: #selector(NSString.localizedStandardCompare))], predicate: NSPredicate(format: "asc == %@ ", ida as UUID as CVarArg))
        fetchRequests = FetchRequest<Grades>(entity: Grades.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare))],predicate: NSPredicate(format: "asc == %@ ", ida as UUID as CVarArg))
        gr = grass
        
        
        ids = idas
        //gra = gras
        
        name = names
        //gra = grasss
    }
    
    @State var sum = 0.0
    @State var newWeight = false
    var color = ColorGen()
    func setup (){
        //ids = ida
        
        
        var su = 0.00
        var s = 0.00
        for i in grades {
            if(i.grade! != "0" && i.grade! != "NULL" && i.total != "NULL"){
                
                var ga = ((Double(i.grade!)!) / Double(i.total!)!) * 100
                ga = ga * (Double(i.percent!) ?? 1.00)
                su = su + ga
                s = s + (Double(i.percent!) ?? 0.00)
            }
        }
        if(s == 0){
            s = 1
        }
        sum = su
        sum = sum / s
        
        
        if("\(sum)" != gr.grade!){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            
            self.gr.setValue("\(sum)", forKey: "grade")
            
            self.gr.setValue("100", forKey: "total")
            
            
            do{
                try context.save()
                print("saved")
                
            } catch{
                print("error")
                
            }
            
        }
        
        
        
        
        
    }
    @State var editMode = false
    var body: some View {
        //NavigationView{
        VStack{
            if (UIDevice.current.userInterfaceIdiom == .pad){
                GeometryReader{ geo in
                    
                    if(self.gr.classname != nil){
                        
                        // Fallback on earlier versions
                        if #available(iOS 14.0, *) {
                            List {
                                Section{
                                    HStack{
                                        Spacer()
                                        VStack{
                                            Text("\(self.sum ,specifier: "%.2f")%")
                                                .foregroundColor(.blue)
                                                .font(.largeTitle)
                                                .minimumScaleFactor(0.01)
                                            Text("Weighted Groups")
                                                .foregroundColor(.green)
                                                .font(.largeTitle)
                                        }
                                        Spacer()
                                    }
                                }
                                ForEach(self.grades, id: \.id){ g in
                                    Section{
                                    NavigationLink(destination: ClassView(idas: g.id!, names: g.classname!, grass: g)) {
                                        
                                       
                                            HStack{
                                                Text("\(g.classname!)")
                                                    .foregroundColor(.white)
                                                    .font(.title)
                                                
                                                Spacer()
                                                VStack{
                                                    if(g.grade != "NULL" && g.total != "NULL"){
                                                        Text("\((((Double(g.grade!) ?? 0.00) / (Double(g.total!) ?? 0.00))*100.00),specifier: "%.2f")%")
                                                            .foregroundColor(.white)
                                                            
                                                            .font(.title)
                                                        Text("Grade")
                                                            .foregroundColor(.white)
                                                        
                                                    } else{
                                                        Text("-")
                                                            .foregroundColor(.white)
                                                            
                                                            .font(.title)
                                                        Text("Grade")
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                            }
                                            
                                            
                                        }
                                    }.onAppear{
                                        setup()
                                    }
                                    .onDisappear{
                                       setup()
                                    }
                                    .listRowBackground(self.color.genColor(grade:((Double(g.grade!) ?? -100000.00) / (Double(g.total!) ?? 1.0) * 100.00)))
                                }
                                .onDelete { indexSet in
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    let context = appDelegate.persistentContainer.viewContext
                                    let fetch = NSFetchRequest<Grades>(entityName: "Grades")
                                    
                                    
                                    fetch.predicate = NSPredicate(format: "asc == %@ ", self.grades[indexSet.first!].id! as CVarArg)
                                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch as! NSFetchRequest<NSFetchRequestResult>)
                                    do {
                                        try context.execute(deleteRequest)
                                    } catch let error as NSError {
                                        // TODO: handle the error
                                        print(error)
                                    }
                                    let deleteItem = self.grades[indexSet.first!]
                                    context.delete(deleteItem)
                                    do {
                                        try context.save()
                                    } catch {
                                        print(error)
                                    }
                                }
                                
                            
                                
                                
                                
                                
                            }
                            
                            .listStyle(InsetGroupedListStyle())
                            .environment(\.horizontalSizeClass, .regular)
                            
                            
                            
                            
                            .onAppear(perform: self.setup)
                            
                            .navigationBarTitle(self.name)
                            
                            .navigationBarItems(trailing:
                                                    HStack{
                                                        Button(action: {self.editMode.toggle()}) {
                                                            
                                                            Text("Edit Class")
                                                                .fontWeight(.semibold)
                                                                .sheet(isPresented: $editMode){
                                                                    EditClass(name: self.gr.classname!, isWeight: self.gr.isWeight,currentTerm: self.gr.term!, cla: self.gr)
                                                                }
                                                        }
                                                        .padding(.trailing)
                                                        
                                                        Button(action: {self.newWeight.toggle()}) {
                                                            
                                                            Text("New Weight")
                                                                .fontWeight(.semibold)
                                                                
                                                                .sheet(isPresented: $newWeight){
                                                                    NewGroup(cla: self.gr)
                                                                }
                                                        }
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                    })
                            
                            //.navigationBarTitle(name)
                            .navigationBarBackButtonHidden(true)
                            .onAppear(perform: self.setup)
                            .padding(.leading, geo.size.height > geo.size.width ? 1 : 0)
                        } else {
                            // Fallback on earlier versions
                            List {
                                Section{
                                    HStack{
                                        Spacer()
                                        VStack{
                                            Text("\(self.sum ,specifier: "%.2f")%")
                                                .foregroundColor(.blue)
                                                .font(.largeTitle)
                                                .minimumScaleFactor(0.01)
                                            Text("Weighted Groups")
                                                .foregroundColor(.green)
                                                .font(.largeTitle)
                                        }
                                        Spacer()
                                    }
                                }
                                ForEach(self.grades, id: \.id){ g in
                                    HStack{
                                        NavigationLink(destination: ClassView(idas: g.id!, names: g.classname!, grass: g)) {
                                            Section{
                                                
                                                HStack{
                                                    Text("\(g.classname!)")
                                                        .foregroundColor(.white)
                                                        .font(.title)
                                                    
                                                    Spacer()
                                                    VStack{
                                                        if(g.grade != "NULL" && g.total != "NULL"){
                                                            Text("\((((Double(g.grade!) ?? 0.00) / (Double(g.total!) ?? 0.00))*100.00),specifier: "%.2f")%")
                                                                .foregroundColor(.white)
                                                                
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                            
                                                        } else{
                                                            Text("-")
                                                                .foregroundColor(.white)
                                                                
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                            
                                        }
                                    }
                                    
                                    .listRowBackground(self.color.genColor(grade:((Double(g.grade!) ?? -100000.00) / (Double(g.total!) ?? 1.0) * 100.00)))
                                    
                                    
                                }
                               
                                
                                .onDelete { indexSet in
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    let context = appDelegate.persistentContainer.viewContext
                                    let fetch = NSFetchRequest<Grades>(entityName: "Grades")
                                    
                                    
                                    fetch.predicate = NSPredicate(format: "asc == %@ ", self.grades[indexSet.first!].id! as CVarArg)
                                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch as! NSFetchRequest<NSFetchRequestResult>)
                                    do {
                                        try context.execute(deleteRequest)
                                    } catch let error as NSError {
                                        // TODO: handle the error
                                        print(error)
                                    }
                                    let deleteItem = self.grades[indexSet.first!]
                                    context.delete(deleteItem)
                                    do {
                                        try context.save()
                                    } catch {
                                        print(error)
                                    }
                                }
                                
                              
                                
                                
                                
                                
                                
                                
                                
                            }
                            
                            .onAppear(perform: self.setup)
                            .listStyle(GroupedListStyle())
                            .environment(\.horizontalSizeClass, .regular)
                            .navigationBarTitle(self.name)
                            
                            .navigationBarItems(trailing:
                                                    HStack{
                                                        Button(action: {self.editMode.toggle()}) {
                                                            
                                                            Text("Edit Class")
                                                                .fontWeight(.semibold)
                                                                .sheet(isPresented: $editMode){
                                                                    EditClass(name: self.gr.classname!, isWeight: self.gr.isWeight,currentTerm: self.gr.term!, cla: self.gr)
                                                                }
                                                        }
                                                        .padding(.trailing)
                                                        
                                                        Button(action: {self.newWeight.toggle()}) {
                                                            
                                                            Text("New Group")
                                                                .fontWeight(.semibold)
                                                                
                                                                .sheet(isPresented: $newWeight){
                                                                    NewGroup(cla: self.gr)
                                                                }
                                                        }
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                    })
                            
                            
                            //.navigationBarTitle(name)
                            .navigationBarBackButtonHidden(true)
                            .environment(\.horizontalSizeClass, .compact)
                            .onAppear(perform: self.setup)
                            .padding(.leading, geo.size.height > geo.size.width ? 1 : 0)
                        }
                    } else{
                        Text("")
                    }
                    
                }
                
            } else{
                
                if #available(iOS 14.0, *) {
                    List {
                        Section{
                            HStack{
                                Spacer()
                                VStack{
                                    Text("\(self.sum ,specifier: "%.2f")%")
                                        .foregroundColor(.blue)
                                        .font(.largeTitle)
                                        .minimumScaleFactor(0.01)
                                    Text("Weighted Groups")
                                        .foregroundColor(.green)
                                        .font(.largeTitle)
                                }
                                Spacer()
                            }
                        }
                        ForEach(self.grades, id: \.self){ g in
                            Section{
                                NavigationLink(destination: ClassView(idas: g.id!, names: g.classname!, grass: g)) {
                                    
                                    HStack{
                                        Text("\(g.classname!)")
                                            .foregroundColor(.white)
                                            .font(.title)
                                        
                                        Spacer()
                                        VStack{
                                            if(g.grade != "NULL" && g.total != "NULL"){
                                                Text("\((((Double(g.grade!) ?? 0.00) / (Double(g.total!) ?? 0.00))*100.00),specifier: "%.2f")%")
                                                    .foregroundColor(.white)
                                                    
                                                    .font(.title)
                                                Text("Grade")
                                                    .foregroundColor(.white)
                                                
                                            } else{
                                                Text("-")
                                                    .foregroundColor(.white)
                                                    
                                                    .font(.title)
                                                Text("Grade")
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        
                                    }
                                    
                                }
                            }
                            
                            .listRowBackground(self.color.genColor(grade:((Double(g.grade!) ?? -100000.00) / (Double(g.total!) ?? 1.0) * 100.00)))
                            .listRowInsets(.init(top: 15, leading: 20, bottom: 15, trailing: 20))
                            
                        }
                        .onDelete { indexSet in
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let context = appDelegate.persistentContainer.viewContext
                            let fetch = NSFetchRequest<Grades>(entityName: "Grades")
                            
                            fetch.predicate = NSPredicate(format: "asc == %@ ", self.grades[indexSet.first!].id! as CVarArg)
                            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch as! NSFetchRequest<NSFetchRequestResult>)
                            do {
                                try context.execute(deleteRequest)
                            } catch let error as NSError {
                                // TODO: handle the error
                                print(error)
                            }
                            let deleteItem = self.grades[indexSet.first!]
                            context.delete(deleteItem)
                            do {
                                try context.save()
                            } catch {
                                print(error)
                            }
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    .listStyle(InsetGroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                    .onAppear(perform: self.setup)
                    
                    .navigationBarTitle(self.name)
                    
                    .navigationBarItems(trailing:
                                            HStack{
                                                Button(action: {self.editMode.toggle()}) {
                                                    
                                                    Text("Edit Class")
                                                        .fontWeight(.semibold)
                                                        .sheet(isPresented: $editMode){
                                                            EditClass(name: self.gr.classname!, isWeight: self.gr.isWeight,currentTerm: self.gr.term!, cla: self.gr)
                                                        }
                                                }
                                                .padding(.trailing)
                                                
                                                Button(action: {self.newWeight.toggle()}) {
                                                    
                                                    Text("New Group")
                                                        .fontWeight(.semibold)
                                                        
                                                        .sheet(isPresented: $newWeight){
                                                            NewGroup(cla: self.gr)
                                                        }
                                                }
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                            })
                } else {
                    // Fallback on earlier versions
                    List {
                        Section{
                            HStack{
                                Spacer()
                                VStack{
                                    Text("\(self.sum ,specifier: "%.2f")%")
                                        .foregroundColor(.blue)
                                        .font(.largeTitle)
                                        .minimumScaleFactor(0.01)
                                    Text("Categories")
                                        .foregroundColor(.green)
                                        .font(.largeTitle)
                                }
                                Spacer()
                            }
                        }
                        ForEach(self.grades, id: \.self){ g in
                            Section{
                                NavigationLink(destination: ClassView(idas: g.id!, names: g.classname!, grass: g)) {
                                    
                                    HStack{
                                        Text("\(g.classname!)")
                                            .foregroundColor(.white)
                                            .font(.title)
                                        
                                        Spacer()
                                        VStack{
                                            if(g.grade != "NULL" && g.total != "NULL"){
                                                Text("\((((Double(g.grade!) ?? 0.00) / (Double(g.total!) ?? 0.00))*100.00),specifier: "%.2f")%")
                                                    .foregroundColor(.white)
                                                    
                                                    .font(.title)
                                                Text("Grade")
                                                    .foregroundColor(.white)
                                                
                                            } else{
                                                Text("-")
                                                    .foregroundColor(.white)
                                                    
                                                    .font(.title)
                                                Text("Grade")
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        
                                    }
                                    
                                }
                            }
                            
                            .listRowBackground(self.color.genColor(grade:((Double(g.grade!) ?? -100000.00) / (Double(g.total!) ?? 1.0) * 100.00)))                        .listRowInsets(.init(top: 15, leading: 20, bottom: 15, trailing: 20))
                            
                        }
                        .onDelete { indexSet in
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let context = appDelegate.persistentContainer.viewContext
                            let fetch = NSFetchRequest<Grades>(entityName: "Grades")
                            
                            fetch.predicate = NSPredicate(format: "asc == %@ ", self.grades[indexSet.first!].id! as CVarArg)
                            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch as! NSFetchRequest<NSFetchRequestResult>)
                            do {
                                try context.execute(deleteRequest)
                            } catch let error as NSError {
                                // TODO: handle the error
                                print(error)
                            }
                            let deleteItem = self.grades[indexSet.first!]
                            context.delete(deleteItem)
                            do {
                                try context.save()
                            } catch {
                                print(error)
                            }
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    .listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                    .onAppear(perform: self.setup)
                    
                    .navigationBarTitle(self.name)
                    
                    .navigationBarItems(trailing:
                                            HStack{
                                                Button(action: {self.editMode.toggle()}) {
                                                    
                                                    Text("Edit Class")
                                                        .fontWeight(.semibold)
                                                        .sheet(isPresented: $editMode){
                                                            EditClass(name: self.gr.classname!, isWeight: self.gr.isWeight,currentTerm: self.gr.term!, cla: self.gr)
                                                        }
                                                }
                                                .padding(.trailing)
                                                
                                                Button(action: {self.newWeight.toggle()}) {
                                                    
                                                    Text("New Weight")
                                                        .fontWeight(.semibold)
                                                        
                                                        .sheet(isPresented: $newWeight){
                                                            NewGroup(cla: self.gr)
                                                        }
                                                }
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                            })
                }
                
                
            }
            
        }
        
        //}
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    
}
//struct ClassView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassView(name: "CS 242")
//    }
//}
