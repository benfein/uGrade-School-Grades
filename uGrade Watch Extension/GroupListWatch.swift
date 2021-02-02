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
    var currentClass: Classes
    var context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    var managedObjectContext = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    var defaultNULL = "NULL"
    var defaultOneHundred = "100"
    @State var grade: Int = 0
    @State var tot: Int = 1
    @ObservedObject var productsStore : ProductsStore

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var proPurchased: Pro
    var gradeNeeded = GradeNeeded()
    var fetchRequests: FetchRequest<Grades>
    var grad: FetchedResults<Grades> {(fetchRequests.wrappedValue)}
    var fetchRequest: FetchRequest<Classes>
    var currentGroupsFetchedResults: FetchedResults<Classes> {(fetchRequest.wrappedValue)}
    
    init(idas: UUID, names:String, grass: Classes, product: ProductsStore) {
        ida = idas
        
        currentClass = grass
        ids = idas
        productsStore = product
        //gra = gras
        fetchRequest = FetchRequest<Classes>(entity: Classes.entity(), sortDescriptors: [NSSortDescriptor(key: "classname", ascending: true, selector: #selector(NSString.localizedStandardCompare))], predicate: NSPredicate(format: "asc == %@ ", ida as UUID as CVarArg))
        fetchRequests = FetchRequest<Grades>(entity: Grades.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare))], predicate: NSPredicate(format: "asc == %@ ", ida as UUID as CVarArg))
        name = names
        //gra = grasss
        
    }
    
    @State var sum = 0.0
    
    var color = ColorGen()
    func setup (){
        var runningGrade = 0.00
        var gradeTotalPoints = 0.00
        for i in currentGroupsFetchedResults {
            if(i.grade! != "0" && i.grade! != "NULL" && i.total != "NULL"){
                var currentWeightedCategory = ((Double(i.grade!)!) / Double(i.total!)!) * 100
                currentWeightedCategory = currentWeightedCategory * (Double(i.percent!) ?? 1.00)
                runningGrade = runningGrade + currentWeightedCategory
                gradeTotalPoints = gradeTotalPoints + (Double(i.percent!) ?? 0.00)
            }
        }
        if(gradeTotalPoints == 0){
            gradeTotalPoints = 1
        }
        sum = runningGrade
        sum = sum / gradeTotalPoints
        if(runningGrade != 0.00){
            var context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext

            self.currentClass.setValue("\(sum)", forKey: "grade")
            self.currentClass.setValue(defaultOneHundred, forKey: "total")
            do{
                try context.save()
                print("saved")
            } catch{
                print("error")
            }
        } else{
            self.currentClass.setValue(defaultNULL, forKey: "grade")
            self.currentClass.setValue(defaultNULL, forKey: "total")
        }
    }
    var body: some View {
        VStack{
            HStack{
                NavigationLink(destination: NewGroupWatch(cla: currentClass)) {
                    Text("+Weight")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                NavigationLink(destination: EditClassWatch(name: self.currentClass.classname!,currentTerm: self.currentClass.term!, isWeight: self.currentClass.isWeight, cla: self.currentClass)) {
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

                ForEach(self.currentGroupsFetchedResults, id: \.self){ currentGroup in
                    HStack{
                    Section{
                        NavigationLink(destination: ClassViewWatch(idas: currentGroup.id!, names: currentGroup.classname!, grass: currentGroup)) {
                            HStack{
                                Text("\(currentGroup.classname!)")
                                    .foregroundColor(.white)
                                Spacer()
                                VStack{
                                    
                                    if(currentGroup.grade != "NULL" && currentGroup.total != "NULL"){
                                        Text("\((((Double(currentGroup.grade!) ?? 0.00) / (Double(currentGroup.total!) ?? 0.00))*100.00),specifier: "%.2f")%")
                                            .foregroundColor(.white)
                                        Text("Grade")
                                            .foregroundColor(.white)
                                    } else{
                                        HStack{
                                                if(self.productsStore.products.count > 0){
                                                if(self.productsStore.products[0].status() == true){
                                                VStack{
                                                    Text("\(gradeNeeded.findWhatIsNeeded(gradeWanted: (Double(currentClass.gradeWanted!) ?? 0.00), classIn: currentClass, currentWeigh: currentGroup, allWeights: currentGroupsFetchedResults),specifier: "%.2f")")
                                                        .font(.body)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)
                                                Text("Needed")
                                                    .foregroundColor(.white)
                                                }
                                                } else{
                                                    VStack{
                                        Text("-")
                                            .foregroundColor(.white)
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
                    }
                    }
                    .listRowBackground(self.color.genColor(grade:((Double(currentGroup.grade!) ?? -100000.00) / (Double(currentGroup.total!) ?? 1.0) * 100.00)))                        
                }
                .onDelete { indexSet in
                    var context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext

                    let allGradesInGroupFetchRequest = NSFetchRequest<Grades>(entityName: "Grades")
                    allGradesInGroupFetchRequest.predicate = NSPredicate(format: "asc == %@ ", self.currentGroupsFetchedResults[indexSet.first!].id! as CVarArg)
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: allGradesInGroupFetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                    do {
                        try context.execute(deleteRequest)
                    } catch let error as NSError {
                        // TODO: handle the error
                        print(error)
                    }
                    let deleteItem = self.currentGroupsFetchedResults[indexSet.first!]
                    context.delete(deleteItem)
                    do {
                        try context.save()
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
