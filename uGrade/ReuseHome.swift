//
//  ReuseHome.swift
//  uGrade
//
//  Created by Ben Fein on 11/13/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import CoreData
import Combine
import StoreKit
struct ReuseHome: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var contact = Classes()
    var color = ColorGen()
    var products: [SKProduct] = []
    @ObservedObject var productsStore : ProductsStore
    @EnvironmentObject var dis: Pro
    @State var shownew = false
    @State var showpro = false
    var sem = [String]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @State var hide = false
    
   
    var fetchRequest: FetchRequest<Classes>
    var clas: FetchedResults<Classes> {(fetchRequest.wrappedValue)}
    init(product: ProductsStore) {
        productsStore = product
        fetchRequest = FetchRequest<Classes>(entity: Classes.entity(), sortDescriptors: [NSSortDescriptor(key: "classname", ascending: true, selector: #selector(NSString.localizedStandardCompare))], predicate: NSPredicate(format: "isGroup == \(false)"))
        //UITableViewCell.appearance().selectionStyle = .none
        let currentDate = Date()
        let format = DateFormatter()
        format.setLocalizedDateFormatFromTemplate("YYYY")
        let currentYearInString = format.string(from: currentDate)
        sem.append("")
        sem.append("No Term")
        for i in stride(from: Int(currentYearInString)! + 4, through: Int(currentYearInString)!, by: -1) {
            sem.append("Fall \(i)")
            sem.append("Summer \(i)")
            sem.append("Spring \(i)")
            
        }
    }
    func setup(){

        if(self.productsStore.products.count > 0){
            if(self.clas.count >= 3 && self.productsStore.products[0].status() == false){
                self.dis.dis = true
                let p = UserDefaults.init(suiteName: "group.com.benfein.ugrade")
                p?.set(true, forKey: "purchased")                                     } else{
                    self.dis.dis = false
                }
        }
        
        
        
    }


    var body: some View {
     
        if #available(iOS 14.0, *) {
            AnyView(
                List{
                    
                    ForEach(self.sem, id: \.self){ i in
                        if(clas.contains{$0.term == i}){
                        Section(header:Text(i)){
                            ForEach(self.clas.filter{$0.term == i}, id: \.self) { cl in
                        
                        
                        Section{
                            HStack{
                                if(cl.isWeight == false){
                                    NavigationLink(destination: ClassView(idas: cl.id!,names: cl.classname!,grass: cl)) {
                                        
                                        
                                        ClassRow(className: "\(cl.classname!)", classGrade:"\((((Double(cl.grade!) ?? 0.00) / (Double(cl.total!) ?? 1.0))) * 100.0)", id: cl.id!)
                                        
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                } else{
                                    
                                    
                                    NavigationLink(destination: GroupList(idas: cl.id!,names: cl.classname!,grass: cl, product: self.productsStore)) {
                                        ClassRow(className: "\(cl.classname!)", classGrade: "\(cl.grade!)", id: cl.id!)
                                    }
                                    
                                    
                                    
                                }
                                
                            }
                        }   .onAppear{
                          setup()
                        }
                        .onDisappear{
                            setup()
                        }
                        
                        
                        
                        
                        
                        
                        .listRowBackground(self.color.genColor(grade: ((Double("\(cl.grade!)")  ?? -1.0) / (Double("\(cl.total!)") ?? 1.0)) * 100.0))
                        
                        .listRowInsets(.init(top: 15, leading: 20, bottom: 15, trailing: 20))
                        
                    }
                    
                    
                    
                    
                    .onDelete { indexSet in
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context = appDelegate.persistentContainer.viewContext
                        let fetch = NSFetchRequest<Classes>(entityName: "Classes")
                        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        
                        
                        fetch.predicate = NSPredicate(format: "asc == %@ ", self.clas.filter{$0.term == i}[indexSet.first!].id! as CVarArg)
                        var r: [Classes] = [Classes]()
                        managedObjectContext.perform{
                            r = try! fetch.execute()
                        }
                        for i in r {
                            let fetchs = NSFetchRequest<NSFetchRequestResult>(entityName: "Grades")
                            fetchs.predicate = NSPredicate(format: "asc == %@ ", i.id! as CVarArg)
                            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchs)
                            do {
                                try context.execute(deleteRequest)
                                
                            } catch let error as NSError {
                                // TODO: handle the error
                                print(error)
                            }
                        }
                        
                        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch as! NSFetchRequest<NSFetchRequestResult>)
                        
                        do {
                            try context.execute(deleteRequest)
                        } catch let error as NSError {
                            // TODO: handle the error
                            print(error)
                        }
                        let deleteItem = self.clas.filter{$0.term == i}[indexSet.first!]
                        context.delete(deleteItem)
                        do {
                            try context.save()
                            
                        } catch {
                            print(error)
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                          
                    .onAppear(perform: self.setup)
                        
                }
                            
                    

                
                        }//end of if
                 } //end of groups
                    
                }
                .onAppear(perform: self.setup)
                .listStyle(InsetGroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
            
                
            
                
            )
            
        } else {
            // Fallback on earlier versions
            AnyView(
                List{
                    
                    ForEach(self.sem, id: \.self){ i in
                        if(clas.contains{$0.term == i}){
                        Section(header:Text(i)){
                            ForEach(self.clas.filter{$0.term == i}, id: \.self) { cl in
                        
                        
                        Section{
                            HStack{
                                if(cl.isWeight == false){
                                    NavigationLink(destination: ClassView(idas: cl.id!,names: cl.classname!,grass: cl)) {
                                        
                                        
                                        ClassRow(className: "\(cl.classname!)", classGrade:"\((((Double(cl.grade!) ?? 0.00) / (Double(cl.total!) ?? 1.0))) * 100.0)", id: cl.id!)
                                        
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                } else{
                                    
                                    
                                    NavigationLink(destination: GroupList(idas: cl.id!,names: cl.classname!,grass: cl, product: self.productsStore)) {
                                        ClassRow(className: "\(cl.classname!)", classGrade: "\(cl.grade!)", id: cl.id!)
                                    }
                                    
                                    
                                    
                                }
                                
                            }
                        }   .onAppear{
                          setup()
                        }
                        .onDisappear{
                            setup()
                        }
                        
                        
                        
                        
                        
                        
                        .listRowBackground(self.color.genColor(grade: ((Double("\(cl.grade!)")  ?? -1.0) / (Double("\(cl.total!)") ?? 1.0)) * 100.0))
                        
                        .listRowInsets(.init(top: 15, leading: 20, bottom: 15, trailing: 20))
                        
                    }
                    
                    
                    
                    
                    .onDelete { indexSet in
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context = appDelegate.persistentContainer.viewContext
                        let fetch = NSFetchRequest<Classes>(entityName: "Classes")
                        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        
                        
                        fetch.predicate = NSPredicate(format: "asc == %@ ", self.clas.filter{$0.term == i}[indexSet.first!].id! as CVarArg)
                        var r: [Classes] = [Classes]()
                        managedObjectContext.perform{
                            r = try! fetch.execute()
                        }
                        for i in r {
                            let fetchs = NSFetchRequest<NSFetchRequestResult>(entityName: "Grades")
                            fetchs.predicate = NSPredicate(format: "asc == %@ ", i.id! as CVarArg)
                            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchs)
                            do {
                                try context.execute(deleteRequest)
                                
                            } catch let error as NSError {
                                // TODO: handle the error
                                print(error)
                            }
                        }
                        
                        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch as! NSFetchRequest<NSFetchRequestResult>)
                        
                        do {
                            try context.execute(deleteRequest)
                        } catch let error as NSError {
                            // TODO: handle the error
                            print(error)
                        }
                        let deleteItem = self.clas.filter{$0.term == i}[indexSet.first!]
                        context.delete(deleteItem)
                        do {
                            try context.save()
                            
                        } catch {
                            print(error)
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                          
                    .onAppear(perform: self.setup)
                        
                }
                            
                    

                
                        }//end of if
                 } //end of groups
                    
                }
                .onAppear(perform: self.setup)
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
            
                
            
                
            )
        }
            }

        }

