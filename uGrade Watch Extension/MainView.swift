//
//  Main.swift
//  uGrade
//
//  Created by Ben Fein on 6/20/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        
        HomeWatch(product: ProductsStore.shared).environmentObject(Pro()).environment(\.managedObjectContext, managedObjectContext)
    }
}

//struct Main_Previews: PreviewProvider {
//    static var previews: some View {
//        Main()
//    }
//}
