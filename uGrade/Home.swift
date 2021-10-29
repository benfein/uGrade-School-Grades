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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var color = ColorGen()
    var products: [SKProduct] = []
    @ObservedObject var productsStore : ProductsStore
    @EnvironmentObject var proPurchased: Pro
    @State var showNewClass = false
    @State var showGetPro = false
    @State var showChangeLetters = false
    @State var newWeight = false
    var terms = [String]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var allClassesFetchRequest: FetchRequest<Classes>
    var allClassesFetchedResults: FetchedResults<Classes> {
        (allClassesFetchRequest.wrappedValue)
    }
    var allGroupsFetchRequest: FetchRequest<Classes>
    var allGroupsFetchedResults: FetchedResults<Classes> {
        (allGroupsFetchRequest.wrappedValue)
    }
    var allGradesFetchRequest: FetchRequest<Grades>
    var allGradesFetchedResults: FetchedResults<Grades> {
        (allGradesFetchRequest.wrappedValue)
    }
    @State var letters = [["93","100","A"], ["90","93","A-"], ["87","90", "B+"],["83","87","B"],["80","83","B-"], ["77","80", "C+"], ["71","77", "C"], ["67","71","C-"], ["63","67","D+"], ["60", "63","D-"], ["0","60","F"]]
    @State var letterGen: PercentToGrade = .init(letter: [["90","93","A"]])
    init(product: ProductsStore) {

        productsStore = product
        allClassesFetchRequest = FetchRequest<Classes>(entity: Classes.entity(), sortDescriptors: [NSSortDescriptor(key: "classname", ascending: true, selector: #selector(NSString.localizedStandardCompare))], predicate: NSPredicate(format: "isGroup == \(false)"))
        allGroupsFetchRequest = FetchRequest<Classes>(entity: Classes.entity(), sortDescriptors: [NSSortDescriptor(key: "classname", ascending: true, selector: #selector(NSString.localizedStandardCompare))], predicate: NSPredicate(format: "isGroup == \(true)"))
        allGradesFetchRequest = FetchRequest<Grades>(entity: Grades.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare))])

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("YYYY")
        let currentYearInString = dateFormatter.string(from: currentDate)
        terms.append("")
        terms.append("No Term")
        for i in stride(from: Int(currentYearInString)! + 4, through: Int(currentYearInString)!, by: -1) {
            terms.append("Fall \(i)")
            terms.append("Summer \(i)")
            terms.append("Spring \(i)")
        }


    }
    func data() -> [Classes]{
       var data : [Classes] = []
        allClassesFetchedResults.filter{$0.isGroup == false}.forEach { data.append($0) }
       return data
     }
    func setup(){

        let ns = UserDefaults()
        if(ns.array(forKey: "letters") as? [[String]] != nil){
            letters = (ns.array(forKey: "letters") as? [[String]])!

        }
        letterGen = PercentToGrade(letter: letters)
        if(self.productsStore.products.count > 0){
            if(self.allClassesFetchedResults.count >= 3 && self.productsStore.products[0].status() == false){
                self.proPurchased.disable = true
                let p = UserDefaults.init(suiteName: "group.com.benfein.ugrade")
                p?.set(true, forKey: "purchased")                                     } else{
                    self.proPurchased.disable = false
                }
        }



    }

    var body: some View {
        VStack{
            if (UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac){
            //if (UIDevice.current.userInterfaceIdiom == .pad){
                    GeometryReader{ geo in
                //if(self.productsStore.products.count > 0){
                    if(model.portrait){


                                VStack{
                                    
                                    
                                    // Fallback on earlier versions
                                    ReuseHome(product: productsStore).environmentObject(proPurchased)
                                        .onAppear(perform: setup)


                                }
                                .navigationBarTitle("uGrade")
                            .background(Color(UIColor.systemGray6))
                          
                               

                        .navigationViewStyle(StackNavigationViewStyle())
                    
                    } else{
                        

                                VStack{



                                    ReuseHome(product: productsStore).environmentObject(proPurchased)
                                        .onAppear(perform: setup)

                                }




                                


                                .navigationBarTitle("uGrade")
                            .background(Color(UIColor.systemGray6))


                        .navigationViewStyle(DoubleColumnNavigationViewStyle())

                    }







                           


                        
                          

                    
                
                               


                            
                        
                        


            
           
                   


                    
                
                
            }
                
              //  }
                    
                } else{
                    VStack{
                   // if(self.productsStore.products.count > 0){
                        

                        ReuseHome(product: productsStore)

                        .navigationBarTitle("uGrade")
                    .background(Color(UIColor.systemGray6))
                        

                
                    }
                    .navigationViewStyle(StackNavigationViewStyle())


            
                            
                            
                      //  }
                        
                        
                        
                        
                    }
                
                
            }
            
        }
        
        
        
        
    }
    
    






struct Home_Previews: PreviewProvider {

    static var previews: some View {

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        ProductsStore.shared.initializeProducts()

        let settings = Pro()
        return Home( product: ProductsStore.shared).environmentObject(settings).environment(\.managedObjectContext, context)
            .environmentObject(Model(isPortrait: UIScreen.main.bounds.width < UIScreen.main.bounds.height))


    }
}


