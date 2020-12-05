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
    
    class HostingController: WKHostingController<MainView> {

    override var body: MainView {
        return MainView()
    }
        
}

     
