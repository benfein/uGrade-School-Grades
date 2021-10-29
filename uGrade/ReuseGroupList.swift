//
//  ReuseGroupList.swift
//  uGrade
//
//  Created by Ben Fein on 12/9/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import CoreData
struct ReuseGroupList: View {
    var name: String = ""
    var ida: UUID
    @EnvironmentObject var dis: Pro
    var gradeNeeded = GradeNeeded()
    @ObservedObject var gr: Classes

    @State var grade: Int = 0
    @State var tot: Int = 1
    @Environment(\.presentationMode) var presentationMode
    
    @State var n = "NULL"
    @State var o = "100"
    var fetchRequests: FetchRequest<Grades>

    var grad: FetchedResults<Grades> {
        (fetchRequests.wrappedValue)
        
    }
    var fetchRequest: FetchRequest<Classes>
    var grades: FetchedResults<Classes> {
        (fetchRequest.wrappedValue)
        
    }
    init(idas: UUID, names:String, grass: Classes, product: ProductsStore) {
        ida = idas
        //productsStore = product
        fetchRequest = FetchRequest<Classes>(entity: Classes.entity(), sortDescriptors: [NSSortDescriptor(key: "classname", ascending: true, selector: #selector(NSString.localizedStandardCompare))], predicate: NSPredicate(format: "asc == %@ ", ida as UUID as CVarArg))
        fetchRequests = FetchRequest<Grades>(entity: Grades.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare))],predicate: NSPredicate(format: "asc == %@ ", ida as UUID as CVarArg))
        gr = grass
        
        
        ids = idas        
        name = names
    }
    func setup (){
        
        
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
        
     
        if(sum != 0.00){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            
            self.gr.setValue("\(sum)", forKey: "grade")
            
            self.gr.setValue(o, forKey: "total")
            
            
            do{
                try context.save()
                print("saved")
                
            } catch{
                print("error")
                
            }
            
        } else{
            self.gr.setValue(n, forKey: "grade")
            self.gr.setValue(n, forKey: "total")

        }
        
        
        
        
        
    }
    var body: some View {
        
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
                                                
                                                .font(.subheadline)
                                            Text("Grade")
                                                .foregroundColor(.white)
                                            
                                        } else{
                                            HStack{
                                                if(dis.dis == false){

                                                VStack{
                                                    Text("\(gradeNeeded.findWhatIsNeeded(gradeWanted: (Double(gr.gradeWanted!) ?? 0.00), classIn: gr, currentWeigh: g, allWeights: grades),specifier: "%.2f")")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)
                                                Text("Grade Needed")
                                                    .foregroundColor(.white)
                                                }
                                                }
                                                VStack{
                                            Text("-")
                                                .foregroundColor(.white)
                                                
                                                .font(.subheadline)
                                            Text("Grade")
                                                .foregroundColor(.white)
                                                }
                                            }
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
                                                        EditClass(name: self.gr.classname!, isWeight: self.gr.isWeight,currentTerm: self.gr.term!,wantedGrade: self.gr.gradeWanted!,  cla: self.gr)
                                                    }
                                            }
                                            
                                            Button(action: {self.newWeight.toggle()}) {
                                                
                                                Text("New Weight")
                                                    .fontWeight(.semibold)
                                                    
                                                    .sheet(isPresented: $newWeight){
                                                        NewGroup(cla: self.gr)
                                                    }
                                            }.padding(.leading)
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                        })
                
                //.navigationBarTitle(name)
                .navigationBarBackButtonHidden(true)
                .onAppear(perform: self.setup)
                
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
                                                    
                                                    .font(.subheadline)
                                                Text("Grade")
                                                    .foregroundColor(.white)
                                                
                                            } else{
                                                HStack{
                                                    if(dis.dis == false){
                                                    VStack{
                                                        Text("\(gradeNeeded.findWhatIsNeeded(gradeWanted: (Double(gr.gradeWanted!) ?? 0.00), classIn: gr, currentWeigh: g, allWeights: grades),specifier: "%.2f")")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(.white)
                                                    Text("Grade Needed")
                                                        .foregroundColor(.white)
                                                    }
                                                    }
                                                    VStack{
                                                Text("-")
                                                    .foregroundColor(.white)
                                                    
                                                    .font(.subheadline)
                                                Text("Grade")
                                                    .foregroundColor(.white)
                                                    }
                                                }
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
                                                        EditClass(name: self.gr.classname!, isWeight: self.gr.isWeight,currentTerm: self.gr.term!,wantedGrade: self.gr.gradeWanted!,  cla: self.gr)
                                                    }
                                            }
                                            
                                            Button(action: {self.newWeight.toggle()}) {
                                                
                                                Text("New Group")
                                                    .fontWeight(.semibold)
                                                    
                                                    .sheet(isPresented: $newWeight){
                                                        NewGroup(cla: self.gr)
                                                    }
                                            }.padding(.leading)
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                        })
                
                
                //.navigationBarTitle(name)
                .navigationBarBackButtonHidden(true)
                .environment(\.horizontalSizeClass, .compact)
                .onAppear(perform: self.setup)
                
            }
        } else{
            Text("")
        }
        
    }

    }


struct ReuseGroupList_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let cl = Classes.init(context: context)
        cl.id = UUID()
        cl.classname = "CS 242"
       return ReuseGroupList(idas: UUID(), names: "CS 242", grass: cl, product: ProductsStore.shared).environment(\.managedObjectContext, context)
    }
    
}

