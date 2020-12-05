//
//  uGradeProducts.swift
//  uGrade
//
//  Created by Ben Fein on 6/15/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import StoreKit
import UIKit
class ProductsStore : ObservableObject {
    
    static let shared = ProductsStore()
    var subscription_1 = "com.benfein.ugrade.removeads"
    @Published var products: [SKProduct] = []
    @Published var anyString = "123"
    
    func handleUpdateStore(){
        DispatchQueue.main.async { () -> Void in
            
            self.anyString = UUID().uuidString
        }
    }
    
    
    func initializeProducts(){
        IAPManager.shared.startWith(arrayOfIds: [subscription_1], sharedSecret: "edeb7d7a2b0f4eeb8c8de9622b175a94") { products in
            self.products = products
        }
    }
    
}
