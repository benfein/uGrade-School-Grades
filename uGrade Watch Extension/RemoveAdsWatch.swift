//
//  RemoveAds.swift
//  uGrade
//
//  Created by Ben Fein on 6/15/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI
import StoreKit
import Combine
import WatchKit
extension SKProduct {
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        let text = formatter.string(from: price)
        return (text ?? "")
    }
}
struct PurchaseButton : View {
    
    var block : SuccessBlock!
    var product : SKProduct!
    
    var body: some View {
        HStack{
            Spacer()
            Button(action: {
                self.block()
            }) {
                Text(product.localizedPrice())
            }
            Spacer()
        }
    }
    
}

struct RemoveAdsWatch: View {
    init() {
        
    }
    var managedObjectContext = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    func dismissButton() -> some View {
        HStack{
            Spacer()
            Button(action: {
                self.dismiss()
                
            }) {
                Text("Not Now")
            }
            Spacer()
        }
    }
    @State private var isDisabled : Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func dismiss() {
        
        self.mode.wrappedValue.dismiss()
    }
    func aboutText() -> some View {
        HStack{
            Spacer()
            Text("""
                   • Keep Track of Unlimited Courses
                   • Help Support Future Development
                   """).font(.body).lineLimit(nil)
            Spacer()
        }
    }
    func purchaseProduct(skproduct : SKProduct){
        print("did tap purchase product: \(skproduct.productIdentifier)")
        isDisabled = true
        IAPManager.shared.purchaseProduct(product: skproduct, success: {
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()

            self.dismiss()
            
        }) { (error) in
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
        }
    }
    func restorePurchases(){
        
        IAPManager.shared.restorePurchases(success: {
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()

            self.presentationMode.wrappedValue.dismiss()

            
            
        }) { (error) in
            self.isDisabled = false
            
            ProductsStore.shared.handleUpdateStore()
            print(error!)
        }
    }
    var block : SuccessBlock!
    var product : SKProduct!
    var body: some View {
        
        
        Form{
            Text("uGrade Pro")
                .font(.title3)
                .fontWeight(.bold)
            Section{
                aboutText()
            }
            HStack{
            ForEach(ProductsStore.shared.products, id: \.self) { prod in
               
                HStack{
                    Spacer()
                    Button(action: {
                        self.purchaseProduct(skproduct: prod)
                       
                    }) {
                        Text(prod.localizedPrice())
                    }.environment(\.managedObjectContext, managedObjectContext)
                    Spacer()
                }.disabled(IAPManager.shared.isProductPurchased(prod.productIdentifier))
                    }
                
            
            }
            
            
            
            Section{
                Button(action: {
                    self.restorePurchases()
                }) {
                    Text("Restore Purchase")
                }
            }
            
            
            
            Section{
                HStack{
                    
                    self.dismissButton()
                    
                }
            }                                        
            
            
        }
        
        .navigationBarTitle(Text("Unlimited Courses"))
        
    }
    
    
    
}



