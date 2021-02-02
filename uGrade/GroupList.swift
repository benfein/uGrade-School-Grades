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
    var className: String = ""
    var currentID: UUID
    @EnvironmentObject var proPurchased: Pro
    var gradeNeeded = GradeNeeded()
    @ObservedObject var currentClass: Classes
    @State var grade: Int = 0
    @State var totalPoints: Int = 1
    @State var defaultNULL = "NULL"
    @State var defaultOneHundred = "100"
    @Environment(\.presentationMode) var presentationMode
    var currentGradesFetchRequest: FetchRequest<Grades>
    var currentGradesFetchedResults: FetchedResults<Grades> {
        (currentGradesFetchRequest.wrappedValue)
    }
    var currentGroupsFetchRequest: FetchRequest<Classes>
    var currentGroupsFetchedResults: FetchedResults<Classes> {
        (currentGroupsFetchRequest.wrappedValue)
    }
    @ObservedObject var productsStore : ProductsStore

    init(currentClassID: UUID, currentClassName:String, currentClass: Classes, productsStore: ProductsStore) {
        currentID = currentClassID
        currentGroupsFetchRequest = FetchRequest<Classes>(entity: Classes.entity(), sortDescriptors: [NSSortDescriptor(key: "classname", ascending: true, selector: #selector(NSString.localizedStandardCompare))], predicate: NSPredicate(format: "asc == %@ ", currentID as UUID as CVarArg))
        currentGradesFetchRequest = FetchRequest<Grades>(entity: Grades.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare))],predicate: NSPredicate(format: "asc == %@ ", currentID as UUID as CVarArg))
        self.currentClass = currentClass
        className = currentClassName
        self.productsStore = productsStore
    }
    @State var gradeSum = 0.0
    @State var newWeight = false
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
        gradeSum = runningGrade
        gradeSum = gradeSum / gradeTotalPoints
        if(runningGrade != 0.00){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            self.currentClass.setValue("\(gradeSum)", forKey: "grade")
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
    @State var editMode = false
    var body: some View {
        //NavigationView{
        VStack{
            if (UIDevice.current.userInterfaceIdiom == .pad){
            // if (UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac){
                GeometryReader{ geo in
                    if(self.currentClass.classname != nil){
                        // Fallback on earlier versions
                        if #available(iOS 14.0, *) {
                            List {
                                Section{
                                    HStack{
                                        Spacer()
                                        VStack{
                                            Text("\(self.gradeSum ,specifier: "%.2f")%")
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


                                
                                ForEach(self.currentGroupsFetchedResults, id: \.id){ currentWeightedGroup in
                                    Section{
                                    NavigationLink(destination: GradesView(currentID: currentWeightedGroup.id!, currentName: currentWeightedGroup.classname!, currentClass: currentWeightedGroup)) {
                                            HStack{
                                                Text("\(currentWeightedGroup.classname!)")
                                                    .foregroundColor(.white)
                                                    .font(.title)
                                                Spacer()
                                                VStack{
                                                    if(currentWeightedGroup.grade != "NULL" && currentWeightedGroup.total != "NULL"){
                                                        Text("\((((Double(currentWeightedGroup.grade!) ?? 0.00) / (Double(currentWeightedGroup.total!) ?? 0.00))*100.00),specifier: "%.2f")%")
                                                            .foregroundColor(.white)
                                                            .minimumScaleFactor(0.05)
                                                            .font(.subheadline)
                                                        Text("Grade")
                                                            .foregroundColor(.white)
                                                    } else{
                                                        HStack{
                                                            if(productsStore.products.count > 0){                    if(productsStore.products[0].status() == true){
                                                            VStack{
                                                                Text("\(gradeNeeded.findWhatIsNeeded(gradeWanted: (Double(currentClass.gradeWanted!) ?? 0.00), classIn: currentClass, currentWeigh: currentWeightedGroup, allWeights: currentGroupsFetchedResults),specifier: "%.2f")")
                                                                .font(.subheadline)
                                                                .fontWeight(.semibold)
                                                                .foregroundColor(.white)
                                                            Text("Needed")
                                                                .foregroundColor(.white)
                                                            }
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
                                    .listRowBackground(self.color.genColor(grade:((Double(currentWeightedGroup.grade!) ?? -100000.00) / (Double(currentWeightedGroup.total!) ?? 1.0) * 100.00)))
                                }
                                .onDelete { indexSet in
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    let context = appDelegate.persistentContainer.viewContext
                                    let allGradesInGroupFetchRequest = NSFetchRequest<Grades>(entityName: "Grades")
                                    allGradesInGroupFetchRequest.predicate = NSPredicate(format: "asc == %@ ", self.currentGroupsFetchedResults[indexSet.first!].id! as CVarArg)
                                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: allGradesInGroupFetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                                    do {
                                        try context.execute(deleteRequest)
                                    } catch let error as NSError {
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
                            .listStyle(InsetGroupedListStyle())
                            .environment(\.horizontalSizeClass, .regular)
                            .onAppear(perform: self.setup)
                            .navigationBarTitle(self.className)
                            .navigationBarItems(trailing:
                                                    HStack{
                                                        Button(action: {self.editMode.toggle()}) {
                                                            Text("Edit Class")
                                                                .fontWeight(.semibold)
                                                                .sheet(isPresented: $editMode){
                                                                    EditClass(name: self.currentClass.classname!, isWeight: self.currentClass.isWeight,currentTerm: self.currentClass.term!,wantedGrade: self.currentClass.gradeWanted!,  cla: self.currentClass)
                                                                }
                                                        }
                                                        Button(action: {self.newWeight.toggle()}) {
                                                            Text("New Weight")
                                                                .fontWeight(.semibold)
                                                                .sheet(isPresented: $newWeight){
                                                                    NewGroup(cla: self.currentClass)
                                                                }
                                                        }.padding(.leading)
                                                    })
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
                                            Text("\(self.gradeSum ,specifier: "%.2f")%")
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
                                ForEach(self.currentGroupsFetchedResults, id: \.id){ currentGroup in
                                    HStack{
                                        NavigationLink(destination: GradesView(currentID: currentGroup.id!, currentName: currentGroup.classname!, currentClass: currentGroup)) {
                                            Section{
                                                HStack{
                                                    Text("\(currentGroup.classname!)")
                                                        .foregroundColor(.white)
                                                        .font(.title)
                                                    Spacer()
                                                    VStack{
                                                        if(currentGroup.grade != "NULL" && currentGroup.total != "NULL"){
                                                            Text("\((((Double(currentGroup.grade!) ?? 0.00) / (Double(currentGroup.total!) ?? 0.00))*100.00),specifier: "%.2f")%")
                                                                .foregroundColor(.white)
                                                                .minimumScaleFactor(0.5)
                                                                .font(.subheadline)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                        } else{
                                                            HStack{
                                                                if(productsStore.products.count > 0){                    if(productsStore.products[0].status() == true){
                                                                VStack{
                                                                    Text("\(gradeNeeded.findWhatIsNeeded(gradeWanted: (Double(currentClass.gradeWanted!) ?? 0.00), classIn: currentClass, currentWeigh: currentGroup, allWeights: currentGroupsFetchedResults),specifier: "%.2f")")
                                                                    .font(.subheadline)
                                                                    .fontWeight(.semibold)
                                                                    .foregroundColor(.white)
                                                                Text("Needed")
                                                                    .foregroundColor(.white)
                                                                }
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
                                    .listRowBackground(self.color.genColor(grade:((Double(currentGroup.grade!) ?? -100000.00) / (Double(currentGroup.total!) ?? 1.0) * 100.00)))
                                }
                                .onDelete { indexSet in
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    let context = appDelegate.persistentContainer.viewContext
                                    let allGradesInGroupFetchRequest = NSFetchRequest<Grades>(entityName: "Grades")
                                    allGradesInGroupFetchRequest.predicate = NSPredicate(format: "asc == %@ ", self.currentGroupsFetchedResults[indexSet.first!].id! as CVarArg)
                                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: allGradesInGroupFetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                                    do {
                                        try context.execute(deleteRequest)
                                    } catch let error as NSError {
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
                            .onAppear(perform: self.setup)
                            .listStyle(GroupedListStyle())
                            .environment(\.horizontalSizeClass, .regular)
                            .navigationBarTitle(self.className)
                            .navigationBarItems(trailing:
                                                    HStack{
                                                        Button(action: {self.editMode.toggle()}) {
                                                            Text("Edit Class")
                                                                .fontWeight(.semibold)
                                                                .sheet(isPresented: $editMode){
                                                                    EditClass(name: self.currentClass.classname!, isWeight: self.currentClass.isWeight,currentTerm: self.currentClass.term!,wantedGrade: self.currentClass.gradeWanted!,  cla: self.currentClass)
                                                                }
                                                        }
                                                        Button(action: {self.newWeight.toggle()}) {
                                                            Text("New Group")
                                                                .fontWeight(.semibold)
                                                                .sheet(isPresented: $newWeight){
                                                                    NewGroup(cla: self.currentClass)
                                                                }
                                                        }.padding(.leading)
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
                                    Text("\(self.gradeSum ,specifier: "%.2f")%")
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
                        ForEach(self.currentGroupsFetchedResults, id: \.self){ currentGroup in
                            Section{
                                NavigationLink(destination: GradesView(currentID: currentGroup.id!, currentName: currentGroup.classname!, currentClass: currentGroup)) {
                                    HStack{
                                        Text("\(currentGroup.classname!)")
                                            .foregroundColor(.white)
                                            .font(.title)
                                        Spacer()
                                        VStack{
                                            if(currentGroup.grade != "NULL" && currentGroup.total != "NULL"){
                                                Text("\((((Double(currentGroup.grade!) ?? 0.00) / (Double(currentGroup.total!) ?? 0.00))*100.00),specifier: "%.2f")%")
                                                    .foregroundColor(.white)
                                                    .font(.subheadline)
                                                Text("Grade")
                                                    .foregroundColor(.white)
                                            } else{
                                                HStack{
                                                    if(productsStore.products.count > 0){                    if(productsStore.products[0].status() == true){
                                                    VStack{
                                                        Text("\(gradeNeeded.findWhatIsNeeded(gradeWanted: (Double(currentClass.gradeWanted!) ?? 0.00), classIn: currentClass, currentWeigh: currentGroup, allWeights: currentGroupsFetchedResults),specifier: "%.2f")")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(.white)
                                                    Text("Needed")
                                                        .foregroundColor(.white)
                                                    }
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
                            .listRowBackground(self.color.genColor(grade:((Double(currentGroup.grade!) ?? -100000.00) / (Double(currentGroup.total!) ?? 1.0) * 100.00)))
                            .listRowInsets(.init(top: 15, leading: 20, bottom: 15, trailing: 20))
                        }
                        .onDelete { indexSet in
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let context = appDelegate.persistentContainer.viewContext
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
                    .listStyle(InsetGroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                    .onAppear(perform: self.setup)
                    .navigationBarTitle(self.className)
                    .navigationBarItems(trailing:
                                            HStack{
                                                Button(action: {self.editMode.toggle()}) {
                                                    Text("Edit Class")
                                                        .fontWeight(.semibold)
                                                        .sheet(isPresented: $editMode){
                                                            EditClass(name: self.currentClass.classname!, isWeight: self.currentClass.isWeight,currentTerm: self.currentClass.term!,wantedGrade: self.currentClass.gradeWanted!,  cla: self.currentClass)
                                                        }
                                                }
                                                Button(action: {self.newWeight.toggle()}) {
                                                    Text("New Group")
                                                        .fontWeight(.semibold)
                                                        .sheet(isPresented: $newWeight){
                                                            NewGroup(cla: self.currentClass)
                                                        }
                                                }.padding(.leading)
                                            })
                } else {
                    // Fallback on earlier versions
                    List {
                        Section{
                            HStack{
                                Spacer()
                                VStack{
                                    Text("\(self.gradeSum ,specifier: "%.2f")%")
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
                        ForEach(self.currentGroupsFetchedResults, id: \.self){ currentGroup in
                            Section{
                                NavigationLink(destination: GradesView(currentID: currentGroup.id!, currentName: currentGroup.classname!, currentClass: currentGroup)) {
                                    HStack{
                                        Text("\(currentGroup.classname!)")
                                            .foregroundColor(.white)
                                            .font(.title)
                                        Spacer()
                                        VStack{
                                            if(currentGroup.grade != "NULL" && currentGroup.total != "NULL"){
                                                Text("\((((Double(currentGroup.grade!) ?? 0.00) / (Double(currentGroup.total!) ?? 0.00))*100.00),specifier: "%.2f")%")
                                                    .foregroundColor(.white)
                                                    .font(.subheadline)
                                                Text("Grade")
                                                    .foregroundColor(.white)
                                            } else{
                                                HStack{
                                                    if(productsStore.products.count > 0){                    if(productsStore.products[0].status() == true){
                                                    VStack{
                                                        Text("\(gradeNeeded.findWhatIsNeeded(gradeWanted: (Double(currentClass.gradeWanted!) ?? 0.00), classIn: currentClass, currentWeigh: currentGroup, allWeights: currentGroupsFetchedResults),specifier: "%.2f")")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(.white)
                                                    Text("Needed")
                                                        .foregroundColor(.white)
                                                    }
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
                            .listRowBackground(self.color.genColor(grade:((Double(currentGroup.grade!) ?? -100000.00) / (Double(currentGroup.total!) ?? 1.0) * 100.00)))                        .listRowInsets(.init(top: 15, leading: 20, bottom: 15, trailing: 20))
                        }
                        .onDelete { indexSet in
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let context = appDelegate.persistentContainer.viewContext
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
                    .listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                    .onAppear(perform: self.setup)
                    .navigationBarTitle(self.className)
                    .navigationBarItems(trailing:
                                            HStack{
                                                Button(action: {self.editMode.toggle()}) {
                                                    Text("Edit Course")
                                                        .fontWeight(.semibold)
                                                        .sheet(isPresented: $editMode){
                                                            EditClass(name: self.currentClass.classname!, isWeight: self.currentClass.isWeight,currentTerm: self.currentClass.term!,wantedGrade: self.currentClass.gradeWanted!,  cla: self.currentClass)
                                                        }
                                                }
                                                Button(action: {self.newWeight.toggle()}) {
                                                    Text("New Group")
                                                        .fontWeight(.semibold)
                                                        .sheet(isPresented: $newWeight){
                                                            NewGroup(cla: self.currentClass)
                                                        }
                                                }.padding(.leading)
                                            })
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
struct GroupList_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let cl = Classes.init(context: context)
        cl.id = UUID()
       return GroupList(currentClassID: UUID(), currentClassName: "CS 242", currentClass: cl, productsStore: ProductsStore.shared).environment(\.managedObjectContext, context)
    }
}
