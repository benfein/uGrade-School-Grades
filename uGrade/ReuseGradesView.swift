//
//  ReuseClassView.swift
//  uGrade
//
//  Created by Ben Fein on 12/9/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//
import SwiftUI
struct ReuseGradesView: View {
    @EnvironmentObject var dis: Pro
    @State var editMode = false
    @State var editMode2 = false
    @State var defaultNULL = "NULL"
    @State var newGrade = false
    var name: String = ""
    var currentID: UUID = UUID()
    @ObservedObject var currentClass: Classes
    @State var grade: Double = 0.0
    @State var tot: Double = 1.0
    var color = ColorGen()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var gradesFetchRequest: FetchRequest<Grades>
    var gradesFetchedResults: FetchedResults<Grades> {
        (gradesFetchRequest.wrappedValue)
    }
    var gradeNeeded = GradeNeeded()
    init(currentID: UUID, currentName:String, currentClass: Classes) {
        self.currentID = currentID
        self.currentClass = currentClass
        self.name = currentName
        gradesFetchRequest = FetchRequest<Grades>(entity: Grades.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare))], predicate: NSPredicate(format: "asc == %@ ", currentID as CVarArg))
    }
    func setup (){
        var gradeRun = 0.0
        var gradeTotalRun = 0.0
        for currentGrade in gradesFetchedResults {
            if(currentGrade.grade != "NULL" && currentGrade.total != "NULL"){
                gradeRun = gradeRun + (Double(currentGrade.grade!) ?? 1.0)
                gradeTotalRun = gradeTotalRun + (Double(currentGrade.total!) ?? 1.0)
            }
        }
        grade = gradeRun

        if(gradeTotalRun != 0.0){
            self.currentClass.setValue("\(gradeRun)", forKey: "grade")
            self.currentClass.setValue("\(gradeTotalRun)", forKey: "total")
        } else{
            self.currentClass.setValue(defaultNULL, forKey: "grade")
            self.currentClass.setValue(defaultNULL, forKey: "total")
        }
        if("\(grade)" != currentClass.grade! || "\(gradeTotalRun)" != currentClass.total!  ){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            do{
                try context.save()
                print("saved")
            } catch{
                print("error")
            }
        }
    }
    var body: some View {
        if(currentClass.classname != nil){
            VStack{
                VStack{
                    HStack{
                        Section{
                            if #available(iOS 14.0, *) {
                                List {
                                    Section{
                                        HStack{
                                        Spacer()
                                        VStack{
                                            Text("\(Double(currentClass.grade!) ?? 0.0,specifier: "%.2f") (\((((Double(currentClass.grade!) ?? 0.00) / (Double(currentClass.total!) ?? 1.0)) * 100.0),specifier: "%.2f"))%")
                                                .foregroundColor(.blue)
                                                .font(.largeTitle)
                                                .minimumScaleFactor(0.01)
                                            Text("Grades")
                                                .foregroundColor(.green)
                                                .font(.largeTitle)
                                        }
                                        Spacer()
                                    }
                                    }
                                    ForEach(gradesFetchedResults, id: \.id){ gradess in
                                        Section{
                                            NavigationLink(destination: EditGrade(name: gradess.name!, grade: gradess.grade!, total: gradess.total!, cla: self.currentClass, gras: gradess)) {
                                                HStack{
                                                    Text("\(gradess.name!)")
                                                        .foregroundColor(.white)
                                                        .font(.title)
                                                    Spacer()
                                                    VStack{
                                                        if(gradess.grade != "NULL" && gradess.total != "NULL"){
                                                            Text("\(gradess.grade!)/\(gradess.total!)")
                                                                .foregroundColor(.white)
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                        } else            if(gradess.grade == "NULL" && gradess.total != "NULL"){
                                                            Text("- /\(gradess.total!)")
                                                                .foregroundColor(.white)
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                        } else            if(gradess.grade != "NULL" && gradess.total == "NULL"){
                                                            Text("\(gradess.grade!)/ -")
                                                                .foregroundColor(.white)
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                        }else            if(gradess.grade == "NULL" && gradess.total == "NULL"){
                                                            Text("- / -")
                                                                .foregroundColor(.white)
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                        }
                                                    }
                                                    .onAppear(perform: self.setup)
                                                }
                                            }
                                            .listRowBackground(self.color.genColor(grade: ((Double("\(gradess.grade!)")  ?? -100000) / (Double("\(gradess.total!)") ?? 1.0)) * 100.0))
                                        }
                                    }.onDelete { indexSet in
                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                        let context = appDelegate.persistentContainer.viewContext
                                        let deleteItem = self.gradesFetchedResults[indexSet.first!]
                                        context.delete(deleteItem)
                                        do {
                                            try context.save()
                                            self.setup()
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                                .listStyle(InsetGroupedListStyle())
                                .environment(\.horizontalSizeClass, .regular)
                                .onAppear(perform: setup)
                            } else {
                                // Fallback on earlier versions
                                List {
                                    HStack{
                                        Spacer()
                                        VStack{
                                            Text("\(Double(currentClass.grade!) ?? 0.0,specifier: "%.2f") (\((((Double(currentClass.grade!) ?? 0.00) / (Double(currentClass.total!) ?? 1.0)) * 100.0),specifier: "%.2f"))%")
                                                .foregroundColor(.blue)
                                                .font(.largeTitle)
                                                .minimumScaleFactor(0.01)
                                            Text("Grades")
                                                .foregroundColor(.green)
                                                .font(.largeTitle)
                                        }
                                        Spacer()
                                    }
                                    ForEach(gradesFetchedResults, id: \.id){ gradess in
                                        Section{
                                            NavigationLink(destination: EditGrade(name: gradess.name!, grade: gradess.grade!, total: gradess.total!, cla: self.currentClass, gras: gradess)) {
                                                HStack{
                                                    Text("\(gradess.name!)")
                                                        .foregroundColor(.white)
                                                        .font(.title)
                                                    Spacer()
                                                    VStack{
                                                        if(gradess.grade != "NULL" && gradess.total != "NULL"){
                                                            Text("\(gradess.grade!)/\(gradess.total!)")
                                                                .foregroundColor(.white)
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                        } else            if(gradess.grade == "NULL" && gradess.total != "NULL"){
                                                            Text("- /\(gradess.total!)")
                                                                .foregroundColor(.white)
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                        } else            if(gradess.grade != "NULL" && gradess.total == "NULL"){
                                                            Text("\(gradess.grade!)/ -")
                                                                .foregroundColor(.white)
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                        }else            if(gradess.grade == "NULL" && gradess.total == "NULL"){
                                                            Text("- / -")
                                                                .foregroundColor(.white)
                                                                .font(.title)
                                                            Text("Grade")
                                                                .foregroundColor(.white)
                                                                .font(.subheadline)
                                                        }
                                                    }
                                                    .onAppear(perform: self.setup)
                                                }
                                            }
                                            .listRowBackground(self.color.genColor(grade: ((Double("\(gradess.grade!)")  ?? -100000) / (Double("\(gradess.total!)") ?? 1.0)) * 100.0))
                                        }
                                    }.onDelete { indexSet in
                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                        let context = appDelegate.persistentContainer.viewContext
                                        let deleteItem = self.gradesFetchedResults[indexSet.first!]
                                        context.delete(deleteItem)
                                        do {
                                            try context.save()
                                            self.setup()
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                                .onAppear(perform: setup)
                            }
                        }
                        .listStyle(GroupedListStyle())
                        .environment(\.horizontalSizeClass, .regular)
                        .background(Color(UIColor.systemGray6))
                    }
                    .navigationBarItems(trailing:
                                            HStack{
                                                if(currentClass.isGroup){
                                                    Button(action: {self.editMode.toggle()}) {

                                                        Text("Edit Group")
                                                            .fontWeight(.semibold)
                                                            .sheet(isPresented: $editMode){
                                                                EditGroup(name: self.currentClass.classname!, percent: self.currentClass.percent!, cla: self.currentClass)
                                                            }
                                                    }

                                                } else{
                                                    Button(action: {self.editMode.toggle()}) {

                                                        Text("Edit Course")
                                                            .fontWeight(.semibold)
                                                            .sheet(isPresented: $editMode){
                                                                EditClass(name: self.currentClass.classname!, isWeight: self.currentClass.isWeight,currentTerm: self.currentClass.term!,wantedGrade: self.currentClass.gradeWanted!,  cla: self.currentClass)
                                                            }
                                                    }
                                                }

                                                Button(action: {self.editMode2.toggle()}) {

                                                    Text("New Grade")
                                                        .fontWeight(.semibold)
                                                        .sheet(isPresented: $editMode2){
                                                            NewGrade(cla: self.currentClass)
                                                        }
                                                }
                                            }
                    )
                }
                .navigationBarTitle(name)
            }
        } else{
            Text("")
        }
    }
}
struct ReuseClassView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let cl = Classes.init(context: context)
        cl.id = UUID()
        cl.grade = "0.00"
        cl.classname = "CS 242"
        cl.total = "0.00"
        return ReuseGradesView(currentID: UUID(), currentName: "CS 242", currentClass: cl).environment(\.managedObjectContext, context).environmentObject(Pro())
    }
}
