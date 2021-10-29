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
    var color = ColorGen()
    var products: [SKProduct] = []
    @ObservedObject var productsStore : ProductsStore
    @EnvironmentObject var proPurchased: Pro
    @State var showNewClass = false
    @State var showGetPro = false
    @State var showChangeLetters = false

    var terms = [String]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var allClassesFetchRequest: FetchRequest<Classes>
    var allClassesFetchedResults: FetchedResults<Classes> {
        (allClassesFetchRequest.wrappedValue)
    }
    @State var letters = [["93","100","A"], ["90","93","A-"], ["87","90", "B+"],["83","87","B"],["80","83","B-"], ["77","80", "C+"], ["71","77", "C"], ["67","71","C-"], ["63","67","D+"], ["60", "63","D-"], ["0","60","F"]]
    @State var letterGen: PercentToGrade = .init(letter: [["90","93","A"]])
    init(product: ProductsStore) {

        productsStore = product
        allClassesFetchRequest = FetchRequest<Classes>(entity: Classes.entity(), sortDescriptors: [NSSortDescriptor(key: "classname", ascending: true, selector: #selector(NSString.localizedStandardCompare))], predicate: NSPredicate(format: "isGroup == \(false)"))
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("YYYY")
        let currentYearInString = dateFormatter.string(from: currentDate)
        terms.append("")
        terms.append("No Term")
        for i in stride(from: 2030, through: 2010, by: -1) {
            terms.append("Fall \(i)")
            terms.append("Summer \(i)")
            terms.append("Spring \(i)")
        }


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
        NavigationView{
            VStack{

                        List{
                            ForEach(self.terms, id: \.self){ i in
                                if(allClassesFetchedResults.contains{$0.term == i}){
                                Section(header:Text("\(i)")){
                                    ForEach(self.allClassesFetchedResults.filter{$0.term == i}, id: \.self) { cl in
                                Section{
                                    HStack{
                                        if(cl.isWeight == false){
                                            NavigationLink(destination: GradesView(currentID: cl.id!,currentName: cl.classname!,currentClass: cl)) {
                                                ClassRow(className: "\(cl.classname!)", classGrade:"\((((Double(cl.grade!) ?? 0.00) / (Double(cl.total!) ?? 1.0))) * 100.0)", id: cl.id!, letter: letterGen.getLetter(grade:"\((((Double(cl.grade!) ?? -1.00) / (Double(cl.total!) ?? 1.0))) * 100.0)"))
                                            }
                                        } else{
                                            NavigationLink(destination: GroupList(currentClassID: cl.id!,currentClassName: cl.classname!,currentClass: cl, productsStore: self.productsStore)) {
                                                ClassRow(className: "\(cl.classname!)", classGrade: "\(cl.grade!)", id: cl.id!, letter: letterGen.getLetter(grade: "\((Double(cl.grade!) ?? -1.00))"))
                                            }
                                        }
                                    }
                                }   .onAppear{
                                  setup()
                                }
                                .onDisappear{
                                    setup()
                                }
                                .listRowBackground(self.color.genColor(grade:((Double(cl.grade!) ?? -100000.00) / (Double(cl.total!) ?? 1.0) * 100.00)))
                                .listRowInsets(.init(top: 15, leading: 20, bottom: 15, trailing: 20))

                            }
                            .onDelete { indexSet in
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                let context = appDelegate.persistentContainer.viewContext
                                let fetch = NSFetchRequest<Classes>(entityName: "Classes")
                                let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                fetch.predicate = NSPredicate(format: "asc == %@ ", self.allClassesFetchedResults.filter{$0.term == i}[indexSet.first!].id! as CVarArg)
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
                                let deleteItem = self.allClassesFetchedResults.filter{$0.term == i}[indexSet.first!]
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
                        .padding(.bottom)
                        .listStyle(InsetGroupedListStyle())
                        .environment(\.horizontalSizeClass, .regular)



                        .navigationBarTitle("uGrade")
                        .navigationBarItems(leading: Section{
                            if(self.productsStore.products.count > 0){
                                if(self.productsStore.products[0].status() == true){
                                Button(action: {self.showChangeLetters.toggle()}) {


                                            Text("Edit Letters")
                                                .fontWeight(.semibold)
                                                .foregroundColor(.green)

                                                .onAppear{
                                                    setup()

                                    }
                                                .sheet(isPresented: self.$showChangeLetters, onDismiss: setup){
                                                    EditLetters(letters: letters)
                                    }
                            }
                            }
                            }
                        },
                                            trailing:
                                                Section{
                        if(self.productsStore.products.count > 0){
                                                Section{
                                                    HStack{
                                                        Spacer()
                                                    if(self.proPurchased.disable == false){
                                                Button(action: {self.showNewClass.toggle()}) {


                                                            Text("New Course")
                                                                .fontWeight(.semibold)
                                                                .foregroundColor(.green)

                                                                .onAppear{
                                                                    setup()

                                                    }
                                                                .sheet(isPresented: self.$showNewClass, onDismiss: setup){
                                                        NewClass()
                                                    }
                                                }

                                                    } else{
                                                                Button(action: {self.showGetPro.toggle()}) {
                                                                    Section{

                                                                            Text("Upgrade Today")
                                                                                .fontWeight(.bold)
                                                                                .foregroundColor(.red)

                                                                                .sheet(isPresented: self.$showGetPro, onDismiss: setup){
                                                                                    RemoveAds().environmentObject(proPurchased)
                                                                    }
                                                                    }
                                                                    .onAppear{
                                                                    setup()
                                                                }
                                                                    .onDisappear{
                                                                        if(self.productsStore.products[0].status() == true){
                                                                            self.proPurchased.disable = false
                                                                        }



                                                                }

                                                                    }
                                                    }

                                                }
                                                }

                        }
                                                }
                        )


            }

        }




}
    }

struct ReuseHome_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ReuseHome( product: ProductsStore.shared).environment(\.managedObjectContext, context)
    }
}
