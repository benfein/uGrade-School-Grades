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
    var letter: String
    init(className: String, classGrade: String, id: UUID, letter: String) {
        self.className = className
        self.classGrade = classGrade
        self.id = id
        self.letter = letter
    }

    var body: some View {
        HStack{
            
            Text(className)
                .foregroundColor(.white)
                .padding(.trailing,5)

            Spacer()
            Text("\(letter)")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.trailing,5)

            VStack{
                Text("\(Double(classGrade) ?? 0.00,specifier: "%.2f")")
                    .foregroundColor(.white)
                    .fontWeight(.bold)


                Text("Grade")
                    .foregroundColor(.white)
                
            }
            
            
        }
        
        
        
        
        
        
    }
}

struct AllClass: View {
    var className: String
    var classGrade: String
    var id: UUID
    
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
            
            
        }
        
        Spacer()
        }
        
        
        
    }
}



struct ClassRow_Previews: PreviewProvider {
    static var previews: some View {
        ClassRow(className: "CS 242", classGrade: "99", id: UUID(), letter: "A")
            .background(Color.green)
            .previewLayout(.sizeThatFits)
    }
}
