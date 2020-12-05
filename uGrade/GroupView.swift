//
//  GroupView.swift
//  uGrade
//
//  Created by Ben Fein on 6/7/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI

struct GroupView: View {
    var name: String = ""
    var ida: UUID = UUID()
    var gr: Classes
    //var gra: Grades
    //var cla: Classes
    
    @State var grade: Double = 0.0
    @State var tot: Double = 1.0
    
    
    var fetchRequest: FetchRequest<Grades>
    var grades: FetchedResults<Grades> {(fetchRequest.wrappedValue)}
    
    init(idas: UUID, names:String, grass: Classes) {
        ida = idas
        gr = grass
        fetchRequest = FetchRequest<Grades>(entity: Grades.entity(), sortDescriptors: [NSSortDescriptor(key: "classname", ascending: true)], predicate: NSPredicate(format: "asc == %@", ida as CVarArg))
        
        
        name = names
        
        ida = idas
        
    }
    
    
    func setup (){
        ids = ida
        var graderun = 0.0
        var totrun = 1.0
        for g in grades {
            graderun = graderun + Double(g.grade!)!
            totrun = totrun + Double(g.total!)!
            
        }
        self.grade = graderun
        if(grades.count > 0){
            tot = totrun
            grade = graderun
        } else{
            tot = 1
            grade = 0
        }
        if("\(grade)" != gr.grade!){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            
            self.gr.setValue("\(grade)", forKey: "grade")
            
            
            
            do{
                try context.save()
                print("saved")
                
            } catch{
                print("error")
                
            }
        }
        ids = ida
    }
    var body: some View {
        VStack{
            Text("(\((Int(Double(self.grade) / Double(self.tot) ) * 100))%)")
                .onAppear(perform: setup)
                
                .foregroundColor(.blue)
                .font(.largeTitle)
            List {
                ForEach(grades, id: \.self){ gradess in
                    HStack{
                        NavigationLink(destination: ClassView(idas:gradess.id!  ,names: gradess.name!, grass:self.gr )) {
                            
                            HStack{
                                
                                Text(gradess.name!)
                                    .foregroundColor(.white)
                                    .font(.title)
                                Spacer()
                                VStack{
                                    Text("\(gradess.grade!)")
                                        .foregroundColor(.white)
                                        
                                        .font(.title)
                                    Text("Current Grade")
                                        .foregroundColor(.white)
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                    }
                }
                .listRowBackground(Color.yellow)
                
                
            }
            
        }
        
        
        .navigationBarTitle(name)
        .navigationBarItems(trailing:
                                HStack{
                                    NavigationLink(destination: NewGrade(cla: gr)) {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                        
                                    }
                                    NavigationLink(destination: NewGroup(cla: gr)) {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                        
                                    }
                                    
                                }
        )
        
    }
}



//struct ClassView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassView(name: "CS 242")
//    }
//}
