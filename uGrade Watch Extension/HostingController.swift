//
//  HostingController.swift
//  uGrade Watch Extension
//
//  Created by Ben Fein on 6/20/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI
    
    class HostingController: WKHostingController<AnyView> {
        var pro = Pro()
        var managedObjectContext = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext

    override var body: AnyView {
        return   AnyView(HomeWatch(product: ProductsStore.shared).environmentObject(Pro()).environment(\.managedObjectContext, managedObjectContext)
                            
        )
    }
    }
        


     
