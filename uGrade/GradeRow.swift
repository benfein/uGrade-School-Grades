//
//  GradeRow.swift
//  uGrade
//
//  Created by Ben Fein on 6/6/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI

struct GradeRow: View {
    @State var name: String
    @State var grade: String
    @State var total: String
    
    @State var asc: UUID
    @State var grades: Grades
    
    var body: some View {
        HStack{
            
            Text("\(name)")
                .foregroundColor(.white)
                .font(.subheadline)
            Spacer()
            VStack{
                Text("\(self.grade)/\(self.total)")
                    .foregroundColor(.white)
                    
                    .font(.subheadline)
                Text("Grade")
                    .foregroundColor(.white)
                
            }
            
        }
        
        
        
        
        
    }
}

//struct GradeRow_Previews: PreviewProvider {
//    static var previews: some View {
//        GradeRow()
//    }
//}
