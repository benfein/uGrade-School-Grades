//
//  GroupList.swift
//  uGrade
//
//  Created by Ben Fein on 6/7/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import CoreData
struct GroupListWatch: View {
    var name: String = ""
    var ida: UUID
    var gr: Classes
    var context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    var managedObjectContext = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    
    @State var grade: Int = 0
    @State var tot: Int = 1
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var fetchRequests: FetchRequest<Grades>
    var grad: FetchedResults<Grades> {(fetchRequests.wrappedValue)}
    var fetchRequest: FetchRequest<Classes>
    var grades: FetchedResults<Classes> {(fetchRequest.wrappedValue)}
    
    init(idas: UUID, names:String, grass: Classes) {
        ida = idas
        
        gr = grass
        ids = idas
        
        //gra = gras
        fetchRequest = FetchRequest<Classes>(entity: Classes.entity(), sortDescriptors: [NSSortDescriptor(key: "classname", ascending: true)], predicate: NSPredicate(format: "asc == %@ ", ida as UUID as CVarArg))
        fetchRequests = FetchRequest<Grades>(entity: Grades.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],predicate: NSPredicate(format: "asc == %@ ", ida as UUID as CVarArg))
        name = names
        //gra = grasss
        
    }
    
    @State var sum = 0.0
    
    var color = ColorGen()
    func setup (){
        //ids = ida
        
        
        var su = 0.00
        var s = 0.00
        for i in grades {
            if(i.grade! != "0" && i.grade! != "NULL" && i.total != "NULL"){
                //print(i.grade!)
                print(i.total!)
                
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
            let context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
            
            
            
            self.gr.setValue("\(sum)", forKey: "grade")
            
            self.gr.setValue("100", forKey: "total")
            
            
            do{
                try context.save()
                print("saved")
                
            } catch{
                print("error")
                
            }
            
        }
        print(sum)
        
        
        
        
    }
    var body: some View {
        VStack{
            HStack{
                NavigationLink(destination: NewGroupWatch(cla: gr)) {
                    Text("+Weight")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                NavigationLink(destination: EditClassWatch(name: self.gr.classname!,currentTerm: self.gr.term!, isWeight: self.gr.isWeight, cla: self.gr)) {
                    Text("Edit")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.trailing)
                    
                }
                
                
            }
            Section{
                HStack{
                    Spacer()
                    VStack{
                        Text("\(self.sum ,specifier: "%.2f")%")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .onAppear(perform: setup)
                        Text("Categories")
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
            }
            
            
            
            
            List {
                
                
                ForEach(self.grades, id: \.self){ g in
                    HStack{
                        Section{
                            NavigationLink(destination: ClassViewWatch(idas: g.id!, names: g.classname!, grass: g)            .environment(\.managedObjectContext, self.managedObjectContext)
                            ) {
                                
                                HStack{
                                    Text("\(g.classname!)")
                                        .foregroundColor(.white)
                                        .font(.body)
                                    
                                    Spacer()
                                    VStack{
                                        if(g.grade != "NULL" && g.total != "NULL"){
                                            Text("\((((Double(g.grade!) ?? 0.00) / (Double(g.total!) ?? 0.00))*100.00),specifier: "%.2f")%")
                                                .foregroundColor(.white)
                                                
                                                .font(.body)
                                            Text("Grade")
                                                .foregroundColor(.white)
                                            
                                        } else{
                                            Text("-")
                                                .foregroundColor(.white)
                                                
                                                .font(.body)
                                            Text("Grade")
                                                .foregroundColor(.white)
                                        }
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                    .listRowBackground(self.color.genColor(grade:((Double(g.grade!) ?? 1.00) / (Double(g.total!) ?? -1.0) * 100.00)))
                    
                    
                    
                    
                }
                .onDelete { indexSet in
                    
                    let fetch = NSFetchRequest<Grades>(entityName: "Grades")
                    
                    fetch.predicate = NSPredicate(format: "asc == %@ ", self.grades[indexSet.first!].id! as CVarArg)
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch as! NSFetchRequest<NSFetchRequestResult>)
                    do {
                        try self.context.execute(deleteRequest)
                    } catch let error as NSError {
                        // TODO: handle the error
                        print(error)
                    }
                    let deleteItem = self.grades[indexSet.first!]
                    self.context.delete(deleteItem)
                    do {
                        try self.context.save()
                    } catch {
                        print(error)
                    }
                }
                
                
                
            }
            
            
            
            
            
            
            
            .navigationBarTitle(name)
            
            .listStyle(CarouselListStyle())
            
            .onAppear(perform: setup)
            
            
        }
        
        
        
        
    }
}




//struct ClassView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassView(name: "CS 242")
//    }
//}
