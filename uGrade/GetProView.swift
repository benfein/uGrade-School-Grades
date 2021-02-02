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

struct RemoveAds: View {
  
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var proPurchased: Pro

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
        if(ProductsStore.shared.products.count > 0){
        self.proPurchased.disable = (!(ProductsStore.shared.products[0].status()))
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    func aboutText() -> some View {
        
        HStack{
            Spacer()
            Text("""
                   • Keep Track of Unlimited Courses
                   • Edit Letter to Grade Values
                   • Set Goals For Weighted Courses and See What You Need to Achieve It
                   • Help Support Future Development
                   """).font(.body).fontWeight(.semibold)
                .lineLimit(nil)
                
            Spacer()
        }
    }
    func purchaseProduct(skproduct : SKProduct){
        print("did tap purchase product: \(skproduct.productIdentifier)")
        isDisabled = true
        IAPManager.shared.purchaseProduct(product: skproduct, success: {
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
            
            self.presentationMode.wrappedValue.dismiss()

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
    var body: some View {
        NavigationView{
        
        Form{
     
            
            Section{
                aboutText()
            }
            
            ForEach(ProductsStore.shared.products, id: \.self) { prod in
                Section{
                    PurchaseButton(block: {
                        self.purchaseProduct(skproduct: prod)
                    }, product: prod).disabled(IAPManager.shared.isProductPurchased(prod.productIdentifier)).environment(\.managedObjectContext, self.managedObjectContext)
                }
            }                                        .listRowInsets(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
            
            
            
            
            Section{
                Button(action: {
                    self.restorePurchases()
                }) {
                    Text("Restore Purchase")
                }
            }                                        .listRowInsets(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
            
            
            
            
            Section{
                HStack{
                    
                    self.dismissButton()
                    
                }
            }                                        .listRowInsets(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
            

        }
        .navigationBarTitle("uGrade Pro")

        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    
}


struct RemoveAds_Previews: PreviewProvider {
    static var previews: some View {
        RemoveAds()
    }
}
