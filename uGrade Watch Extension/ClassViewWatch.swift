//
//  ClassViewWatch.swift
//  uGrade Watch Extension
//
//  Created by Ben Fein on 6/20/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI

var ids: UUID = UUID()
var from = false

struct ClassViewWatch: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var name: String = ""
    var ida: UUID = UUID()
    @ObservedObject var gr: Classes
    
    //var gra: Grades
    var fetchRequests: FetchRequest<Grades>
    var managedObjectContext = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext

    @State var grade: Double = 0.0
    @State var tot: Double = 1.0
    var color = ColorGen()
    init(idas: UUID, names:String, grass: Classes) {
        ida = idas
        
        
        //gra = gras
        fetchRequests = FetchRequest<Grades>(entity: Grades.entity(), sortDescriptors:[], predicate: NSPredicate(format: "asc == %@ ", ida as CVarArg))
        gr = grass
        
        ids = idas
        name = names
        ida = idas
        //gra = grasss
    }
    
    
    //@Environment(\.presentationMode) var mode
    
    
    
    func setup (){
        ids = ida
        var graderun = 0.0
        var totrun = 0.0
        
        for g in fetchRequests.wrappedValue {
            if(g.grade != "NULL" && g.total != "NULL"){
                graderun = graderun + (Double(g.grade!) ?? 1.0)
                totrun = totrun + (Double(g.total!) ?? 1.0)
            }
            
        }
        
        grade = graderun
        
        
        //        if(totrun == 0.0){
        //            totrun = 1
        //        }
        if(totrun != 0.0){
            self.gr.setValue("\(graderun)", forKey: "grade")
            self.gr.setValue("\(totrun)", forKey: "total")
        } else{
            self.gr.setValue("NULL", forKey: "grade")
            self.gr.setValue("NULL", forKey: "total")
        }
        if("\(grade)" != gr.grade! || "\(totrun)" != gr.total!  ){
            
            
            
            
            
            
            do{
                try managedObjectContext.save()
                print("saved")
                
            } catch{
                print("error")
                
            }
        }
    }
    var body: some View {
        
        
        VStack{
            HStack{
                Section{                                     NavigationLink(destination: NewGradeWatch(cla: gr)) {
                    Text("+ Grade")
                    
                    
                    
                }
                
                
                
                HStack{
                    if(gr.isGroup){
                        NavigationLink(destination: EditGroupWatch(name: gr.classname!, percent: gr.percent!, cla: gr)) {
                            Text("Edit")
                            
                        }
                        
                    } else{
                        NavigationLink(destination: EditClassWatch(name: self.gr.classname!, currentTerm: self.gr.term!, isWeight: self.gr.isWeight, cla: self.gr)) {
                            Text("Edit")
                            
                        }
                        
                    }
                    
                }
                
                }
                
            }
            Section{
                HStack{
                    Spacer()
                    VStack{
                        Text("\(Double(gr.grade!) ?? 0.0,specifier: "%.2f") (\((((Double(gr.grade!) ?? 0.00) / (Double(gr.total!) ?? 1.0)) * 100.0),specifier: "%.2f"))%")
                            .foregroundColor(.blue)
                            .minimumScaleFactor(0.01)
                        
                        
                        Text("Grades")
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
            }
            
            List {
                
                
                
                
                
                
                
                
                
                
                
                ForEach(fetchRequests.wrappedValue, id: \.self){ gradess in
                    HStack{
                        Section{
                            
                            NavigationLink(destination: EditGradeWatch(name: gradess.name!, grade: gradess.grade!, total: gradess.total!, cla: self.gr, gras: gradess)) {
                                
                                
                                HStack{
                                    Text("\(gradess.name!)")
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    VStack{
                                        if(gradess.grade != "NULL" && gradess.total != "NULL"){
                                            Text("\(gradess.grade!)/\(gradess.total!)")
                                                .foregroundColor(.white)
                                            
                                            
                                            Text("Grade")
                                                .foregroundColor(.white)
                                            
                                        } else            if(gradess.grade == "NULL" && gradess.total != "NULL"){
                                            Text("- /\(gradess.total!)")
                                                .foregroundColor(.white)
                                            
                                            
                                            Text("Grade")
                                                .foregroundColor(.white)
                                            
                                            
                                        } else            if(gradess.grade != "NULL" && gradess.total == "NULL"){
                                            Text("\(gradess.grade!)/ -")
                                                .foregroundColor(.white)
                                            
                                            
                                            
                                            Text("Grade")
                                                .foregroundColor(.white)
                                            
                                            
                                        }else            if(gradess.grade == "NULL" && gradess.total == "NULL"){
                                            Text("- / -")
                                                .foregroundColor(.white)
                                            
                                            
                                            Text("Grade")
                                                .foregroundColor(.white)
                                            
                                            
                                        }
                                    }
                                }
                                .onAppear(perform: self.setup)
                            }
                            
                            
                        }
                    }
                    .listRowBackground(self.color.genColor(grade: ((Double("\(gradess.grade!)")  ?? 1.0) / (Double("\(gradess.total!)") ?? 1.0)) * 100.0))
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    //.listRowInsets(.init(top: 15, leading: 20, bottom: 15, trailing: 20))
                    
                    
                    
                }
                .onDelete { indexSet in
                    
                    let deleteItem = self.fetchRequests.wrappedValue[indexSet.first!]
                    self.managedObjectContext.delete(deleteItem)
                    do {
                        try self.managedObjectContext.save()
                        self.setup()
                    } catch {
                        print(error)
                    }
                }
                
                
                
            }
            
            .onAppear(perform: setup)
            
            .listStyle(CarouselListStyle())
            
            
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    
}





//struct ClassView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassView(name: "CS 242")
//    }
//}

