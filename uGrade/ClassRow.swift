//
//  ClassRow.swift
//  uGrade
//
//  Created by Ben Fein on 6/5/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
struct ClassRow: View {
    var className: String
    var classGrade: String
    var id: UUID
    func change(){
        idcode = id
    }
    var body: some View {
        HStack{
            
            Text(className)
                .foregroundColor(.white)
                .font(.subheadline)
            Spacer()
            VStack{
                Text("\(Double(classGrade)!,specifier: "%.2f")")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.subheadline)
                Text("Current Grade")
                    .foregroundColor(.white)
                
            }
            
            
        }.onDisappear(perform: change)
        
        
        
        
        
        
    }
}

struct AllClass: View {
    var className: String
    var classGrade: String
    var id: UUID
    func change(){
        idcode = id
    }
    var body: some View {
        VStack{
            Spacer()
        HStack{
            
            Text(className)
                .font(.subheadline)
                .fontWeight(.semibold)
            Spacer()
            VStack{
                Text("\(Double(classGrade)!,specifier: "%.2f")")
                    .fontWeight(.bold)
                    .font(.subheadline)
                Text("Current Grade")
                
            }
            
            
        }.onDisappear(perform: change)
        
        Spacer()
        }
        
        
        
    }
}



//struct ClassRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassRow(className: "CS 242", classGrade: "99", id: UUID())
//            .previewLayout(.sizeThatFits)
//    }
//}
