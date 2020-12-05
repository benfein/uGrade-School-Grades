////
////  ContentView.swift
////  uGrade
////
////  Created by Ben Fein on 6/5/20.
////  Copyright © 2020 Ben Fein. All rights reserved.
////
//
//import SwiftUI
//import CoreData
//import StoreKit
//
//
//
//struct AllGrades: View {
//    
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        @State var hide = false
//
//    var products: [SKProduct] = []
//    @ObservedObject var productsStore : ProductsStore
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    var contact = Classes()
//    var color = ColorGen()
//    var fetchRequests: FetchRequest<Classes>
//    var classs: FetchedResults<Classes> {(fetchRequests.wrappedValue)}
//    init(product: ProductsStore) {
//        fetchRequests = FetchRequest<Classes>(entity: Classes.entity(), sortDescriptors: [NSSortDescriptor(key: "classname", ascending: true)], predicate: NSPredicate(format: "isGroup == \(false)"))
//productsStore = product
//        //UITableViewCell.appearance().selectionStyle = .none
//    }
//    
//    func setup(){
//
//    }
//    
//    var body: some View {
//    
//        
//        
//        VStack{
//       
//                List{
//                    
//                    ForEach(self.classs, id: \.id) { cl in
//                        Section{
//                            
//                            if(cl.isWeight == false){
//                                NavigationLink(destination: ClassView(idas: cl.id!,names: cl.classname!,grass: cl)) {
//                                    
//                                    AllClass(className: "\(cl.classname!)", classGrade:"\(((Double(cl.grade!)! / (Double(cl.total!) ?? 1.0))) * 100.0)", id: cl.id!)
//                                    
//                                    
//                                }
//                                
//                                
//                                
//                                
//                                
//                                
//                                
//                                
//                                
//                            } else{
//                                
//                                
//                                NavigationLink(destination: GroupList(idas: cl.id!,names: cl.classname!,grass: cl, product: self.productsStore)) {
//                                    AllClass(className: "\(cl.classname!)", classGrade: "\(cl.grade!)", id: cl.id!)
//                                    
//                                }
//                                
//                                
//                            }
//                            
//                            
//                            
//                            
//                        }
//                        .listRowBackground(self.color.genColor(grade:((Double(cl.grade!)!/Double(cl.total!)!)*100.00)))
//                    }
//                    
//                    
//                    
//                    
//                    
//                }
//                
//                
//                
//                .listStyle(GroupedListStyle())
//                .environment(\.horizontalSizeClass, .regular)
//            }
//            
//            
//       
//        
//                                   .onAppear(perform: self.setup)
//                
//            
//                
//
//         
//    }
//                
//            
//             
//                                                        
//                                            
//               
//                
//        }
//       
//        
//     
//                 
//
//    
//
//
////struct Home_Previews: PreviewProvider {
////
////
////    static var previews: some View {
////        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
////        return Home().environment(\.managedObjectContext, context)
////    }
////}
