//
//  ContentView.swift
//  uGrade
//
//  Created by Ben Fein on 6/5/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import CoreData
import StoreKit
var idcode: UUID = UUID()



struct Home: View {

    @EnvironmentObject var model: Model

    @EnvironmentObject var dis: Pro
    @State var shownew = false
    @State var showpro = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @State var hide = false
    
    var products: [SKProduct] = []
    @ObservedObject var productsStore : ProductsStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var contact = Classes()
    var color = ColorGen()
    var fetchRequest: FetchRequest<Classes>
    var clas: FetchedResults<Classes> {(fetchRequest.wrappedValue)}
    var sem = [String]()
    init(product: ProductsStore) {
        productsStore = product
        
        fetchRequest = FetchRequest<Classes>(entity: Classes.entity(), sortDescriptors: [NSSortDescriptor(key: "classname", ascending: true)], predicate: NSPredicate(format: "isGroup == \(false)"))
        //UITableViewCell.appearance().selectionStyle = .none
        
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
        NotificationCenter.default.post(name: .my_onViewWillTransition, object: nil, userInfo: ["size": UIScreen.main.bounds])

    }

    
    var body: some View {
        VStack{
          //if (UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac){
               if (UIDevice.current.userInterfaceIdiom == .pad){
                    GeometryReader{ geo in
                if(self.productsStore.products.count > 0){
                    if(model.portrait){

                        NavigationView{
                                VStack{
                                    
                                    
                                    // Fallback on earlier versions
                                    ReuseHome(product: productsStore)
                                        .onAppear(perform: setup)

                                        .navigationBarItems(
                                                            trailing:
                                                                
                                                                Section{
                                                                    HStack{
                                                                        Spacer()
                                                                    if(self.dis.dis == false){
                                                                Button(action: {self.shownew.toggle()}) {
                                                                
                                                                            
                                                                            Text("New Course")
                                                                                .fontWeight(.semibold)
                                                                                .foregroundColor(.green)

                                                                                .onAppear{
                                                                                    setup()
                                                                                
                                                                    }
                                                                                .sheet(isPresented: self.$shownew, onDismiss: setup){
                                                                        NewClass()
                                                                    }
                                                                }

                                                                    } else{
                                                    
                                                                                Button(action: {self.showpro.toggle()}) {
                                                                                    Section{
                                                                                            
                                                                                            Text("Upgrade Today")
                                                                                                .fontWeight(.bold)
                                                                                                .foregroundColor(.red)
                                                                                    
                                                                                                .sheet(isPresented: self.$showpro, onDismiss: setup){
                                                                                        RemoveAds()
                                                                                    }
                                                                                    }
                                                                                    .onAppear{
                                                                                    setup()
                                                                                }
                                                                                    .onDisappear{
                                                                                        if(self.productsStore.products[0].status() == true){
                                                                                            self.dis.dis = false
                                                                                        }
                                                                                    
                                                                                
                                                                                    }
                                                                            
                                                                                    }
                                                                    }
                                                                
                                                                }
                                                                }
                                        
                                        )
                                    
                                    
                                }
                                .navigationBarTitle("uGrade")
                            .background(Color(UIColor.systemGray6))
                          
                               
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                    
                    } else{
                        
                        NavigationView{
                                VStack{
                                    
                                    
                                    // Fallback on earlier versions
                                    ReuseHome(product: productsStore)
                                        .onAppear(perform: setup)
                                       
                                  
                           
                                .navigationBarTitle("uGrade")
                           
                                        .navigationBarItems(
                                                            trailing:
                                                                
                                                                Section{
                                                                    HStack{
                                                                        Spacer()
                                                                    if(self.dis.dis == false){
                                                                Button(action: {self.shownew.toggle()}) {
                                                                
                                                                            
                                                                            Text("New Course")
                                                                                .fontWeight(.semibold)
                                                                                .foregroundColor(.green)

                                                                                .onAppear{
                                                                                    setup()
                                                                                
                                                                    }
                                                                                .sheet(isPresented: self.$shownew, onDismiss: setup){
                                                                        NewClass()
                                                                    }
                                                                }

                                                                    } else{
                                                    
                                                                                Button(action: {self.showpro.toggle()}) {
                                                                                    Section{
                                                                                            
                                                                                            Text("Upgrade Today")
                                                                                                .fontWeight(.bold)
                                                                                                .foregroundColor(.red)
                                                                                    
                                                                                                .sheet(isPresented: self.$showpro, onDismiss: setup){
                                                                                        RemoveAds()
                                                                                    }
                                                                                    }
                                                                                    .onAppear{
                                                                                    setup()
                                                                                }
                                                                                    .onDisappear{
                                                                                        if(self.productsStore.products[0].status() == true){
                                                                                            self.dis.dis = false
                                                                                        }
                                                                                    
                                                                                
                                                                                    }
                                                                            
                                                                                    }
                                                                    }
                                                                
                                                                }
                                                                }
                                        
                                        )
                              

                                 
                        
                          
                        .navigationViewStyle(DoubleColumnNavigationViewStyle())

                    
                
                               


                            
                        
                        
                    }
                            Form{
                                
                            }
                        
                        }
                        
                    }
            
           
                   


                    
                
                
            }
                
                }
                    
                } else{
                    VStack{
                    if(self.productsStore.products.count > 0){

                    NavigationView{
                        GeometryReader{ geo in
                            VStack{
                                
                                
                                // Fallback on earlier versions
                                ReuseHome(product: productsStore)
                                    .onAppear(perform: setup)
                                   
                            
                       
                       

                            }
                    
                            .navigationBarItems(
                                                trailing:
                                                    
                                                    Section{
                                                        HStack{
                                                            Spacer()
                                                        if(self.dis.dis == false){
                                                    Button(action: {self.shownew.toggle()}) {
                                                    
                                                                
                                                                Text("New Course")
                                                                    .fontWeight(.semibold)
                                                                    .foregroundColor(.green)

                                                                    .onAppear{
                                                                        setup()
                                                                    
                                                        }
                                                                    .sheet(isPresented: self.$shownew, onDismiss: setup){
                                                            NewClass()
                                                        }
                                                    }

                                                        } else{
                                        
                                                                    Button(action: {self.showpro.toggle()}) {
                                                                        Section{
                                                                                
                                                                                Text("Upgrade Today")
                                                                                    .fontWeight(.bold)
                                                                                    .foregroundColor(.red)
                                                                        
                                                                                    .sheet(isPresented: self.$showpro, onDismiss: setup){
                                                                            RemoveAds()
                                                                        }
                                                                        }
                                                                        .onAppear{
                                                                        setup()
                                                                    }
                                                                        .onDisappear{
                                                                            if(self.productsStore.products[0].status() == true){
                                                                                self.dis.dis = false
                                                                            }
                                                                        
                                                                    
                                                                        }
                                                                
                                                                        }
                                                        }
                                                    
                                                    }
                                                    }
                            
                            )
                            .onAppear(perform: setup)
                          
                            }

                        .navigationBarTitle("uGrade")
                    .background(Color(UIColor.systemGray6))
                        

                
                    }
                    .navigationViewStyle(StackNavigationViewStyle())


            }
                            
                            
                        }
                        
                        
                        
                        
                    }
                
                
            }
            
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

