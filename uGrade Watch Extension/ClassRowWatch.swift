//
//  ClassRowWatch.swift
//  uGrade Watch Extension
//
//  Created by Ben Fein on 6/20/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
struct ClassRowWatch: View {
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
                Text("\((Double(classGrade) ?? 0.00),specifier: "%.2f")")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.subheadline)
                
                
            }
            
            
        }.onDisappear(perform: change)
        
        
        
        
        
        
    }
}
