//
//  IAPManager.swift
//  uGrade
//
//  Created by Ben Fein on 6/15/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//
//
import UIKit
import SwiftUI
import StoreKit
public typealias SuccessBlock = () -> Void
public typealias FailureBlock = (Error?) -> Void
public typealias ProductsBlock = ([SKProduct]) -> Void
let IAP_PRODUCTS_DID_LOAD_NOTIFICATION = Notification.Name("IAP_PRODUCTS_DID_LOAD_NOTIFICATION")
public typealias ProductIdentifier = String
extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}
class IAPManager : NSObject{
    var request: SKProductsRequest!
    private var sharedSecret = ""
    @objc static let shared = IAPManager()
    @objc private(set) var products = [SKProduct]()
    private override init(){}
    private var productIds : Set<String> = []
    private var didLoadsProducts : ProductsBlock?
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var successBlock : SuccessBlock?
    private var failureBlock : FailureBlock?
    func startWith(arrayOfIds : Set<String>!, sharedSecret : String, callback : @escaping  ProductsBlock){
        productIds = arrayOfIds
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            } else {
                print("Not purchased: \(productIdentifier)")
            }
        }
        SKPaymentQueue.default().add(self)
        self.didLoadsProducts = callback
        self.sharedSecret = sharedSecret
        self.productIds = arrayOfIds
        loadProducts()
    }
    func purchaseProduct(product : SKProduct, success: @escaping SuccessBlock, failure: @escaping FailureBlock){
        guard SKPaymentQueue.canMakePayments() else {
            return
        }
        guard SKPaymentQueue.default().transactions.last?.transactionState != .purchasing else {
            return
        }
        self.successBlock = success
        self.failureBlock = failure
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    func restorePurchases(success: @escaping SuccessBlock, failure: @escaping FailureBlock){
        self.successBlock = success
        self.failureBlock = failure
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    // MARK:- Main methods
    public func buyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    private func loadProducts(){
        request = SKProductsRequest.init(productIdentifiers: productIds)
        request.delegate = self
        request.start()
    }
}
extension IAPManager : SKRequestDelegate {
}
// MARK:- SKReceipt Refresh Request Delegate
// MARK:- SKProducts Request Delegate
extension IAPManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: IAP_PRODUCTS_DID_LOAD_NOTIFICATION, object: nil)
            if response.products.count > 0 {
                self.didLoadsProducts?(self.products)
                self.didLoadsProducts = nil
            }
        }
    }
}
extension SKProduct {
    func status() -> Bool {
        print(IAPManager.shared.isProductPurchased(productIdentifier))
        return IAPManager.shared.isProductPurchased(productIdentifier)
    }
}
// MARK:- SKPayment Transaction Observer
extension IAPManager: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                print("ERROR")
            }
        }
    }
    private func complete(transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
    }
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        SKPaymentQueue.default().finishTransaction(transaction)
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
    }
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?,
           let localizedDescription = transaction.error?.localizedDescription,
           transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
            failureBlock?(transactionError)
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
        self.successBlock?()
    }
    func cleanUp(){
        self.successBlock = nil
        self.failureBlock = nil
    }
}
