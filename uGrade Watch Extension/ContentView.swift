//
//  ContentView.swift
//  uGrade Watch WatchKit Extension
//
//  Created by Ben Fein on 6/20/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//
import SwiftUI
import CoreData
import CloudKit
import StoreKit
var idcode = UUID()
struct HomeWatch: View {
    @EnvironmentObject var proPurchased: Pro
    
    var managedObjectContext = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    var sem = [String]()
    var products: [SKProduct] = []
    @ObservedObject var productsStore : ProductsStore
    var contact = Classes()
    @State var getPro = false
    var color = ColorGen()
    @State var pur = false
    var fetchRequest: FetchRequest<Classes>
    var clas: FetchedResults<Classes> {(fetchRequest.wrappedValue)}
    init(product: ProductsStore) {
        productsStore = product
        fetchRequest = FetchRequest<Classes>(entity: Classes.entity(), sortDescriptors: [NSSortDescriptor(key: "classname", ascending: true)], predicate: NSPredicate(format: "isGroup == \(false)"))
        //UITableViewCell.appearance().selectionStyle = .none
        let currentDate = Date()
        let format = DateFormatter()
        format.setLocalizedDateFormatFromTemplate("YYYY")
        let currentYearInString = format.string(from: currentDate)
        sem.append("")
        sem.append("No Term")
        for i in stride(from: 2030, through: 2010, by: -1) {
            sem.append("Fall \(i)")
            sem.append("Summer \(i)")
            sem.append("Spring \(i)")
            
        }
    }
    
    func setup(){
        productsStore.initializeProducts()
        if(self.productsStore.products.count > 0){
            if(self.clas.count >= 3 && self.productsStore.products[0].status() == false){
                self.proPurchased.disable = true
            } else{
                self.proPurchased.disable = false
            }
        }
        
    }
    
    
    var body: some View {
        
        
        VStack{
        NavigationView{
        //if(self.productsStore.products.count > 0){

        VStack{
           
                VStack{
                    if(self.proPurchased.disable == false){
                    NavigationLink(destination: NewClassWatch().environment(\.managedObjectContext, self.managedObjectContext) ){
                            Text("New Course")
                        
                        }
                    } else{
                        Button(action: {self.getPro.toggle()}) {
                            Section{
                               
                                    
                                  
                                    Text("Upgrade Today")
                                        .fontWeight(.semibold)
                                        .sheet(isPresented: self.$getPro){
                                            RemoveAdsWatch()
                                
                            
                            
                          
                            }
                        }
                    }
                    }
                
                      
                   
                        
                
                List{
                    
                    ForEach(self.sem, id: \.self){ p in
                        if(clas.contains{$0.term == p}){
                        Section(header:Text(p)){
                            ForEach(self.clas.filter{$0.term == p}, id: \.self) { cl in
                        
                        
                        Section{
                            HStack{
                                if(cl.isWeight == false){
                                    NavigationLink(destination: ClassViewWatch(idas: cl.id!,names: cl.classname!,grass: cl)) {
                                        
                                        
                                        ClassRowWatch(className: "\(cl.classname!)", classGrade:"\((((Double(cl.grade!) ?? 0.00) / (Double(cl.total!) ?? 1.0))) * 100.0)", id: cl.id!)
                                        
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                } else{
                                    
                                    
                                    NavigationLink(destination: GroupListWatch(idas: cl.id!,names: cl.classname!,grass: cl, product: productsStore).environmentObject(proPurchased)) {
                                        ClassRowWatch(className: "\(cl.classname!)", classGrade: "\(cl.grade!)", id: cl.id!)
                                    }
                                    
                                    
                                    
                                }
                                
                            }
                        }   .onAppear{
                          setup()
                        }
                       
                        
                        
                        
                        
                        
                        .listRowBackground(self.color.genColor(grade: ((Double("\(cl.grade!)")  ?? -1.0) / (Double("\(cl.total!)") ?? 1.0)) * 100.0))
                        
                        .listRowInsets(.init(top: 15, leading: 20, bottom: 15, trailing: 20))
                        
                    }
                    
                    
                    
                    
                    .onDelete { indexSet in
                        let context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
                        let fetch = NSFetchRequest<Classes>(entityName: "Classes")
                        let managedObjectContext = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
                        
                        
                        fetch.predicate = NSPredicate(format: "asc == %@ ", self.clas.filter{$0.term == p}[indexSet.first!].id! as CVarArg)
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
                        let deleteItem = self.clas.filter{$0.term == p}[indexSet.first!]
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
               
              
            }// end of if for count
        } //end of vstack
        } //end of nav
        }
        
        
        
        
  //  }
    
    
    
    }
}











//struct Home_Previews: PreviewProvider {
//
//
//    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        return Home().environment(\.managedObjectContext, context)
//    }
//}

