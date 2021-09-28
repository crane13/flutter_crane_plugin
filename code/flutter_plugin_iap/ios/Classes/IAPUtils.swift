//
//  IAPUtils.swift
//  Runner
//
//  Created by crane on 2019/9/14.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import SwiftyStoreKit
class IAPUtils: NSObject{
    let SKU_ID:String = "remove_ad"
    let SKU_NATURE_ID:String = "remove_ad"
    
    var isBuy: Bool = false
    
    var flutterResult: FlutterResult!;
    
    static let sharedInstance = IAPUtils()
    
    
    func initIAP() {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        
    }
    
    
    
    func getList(sku_id: String, flutterResult: @escaping FlutterResult) {
        SwiftyStoreKit.retrieveProductsInfo([sku_id]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
                
                if(flutterResult != nil)
                {
                    
                    flutterResult(priceString);
                }
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
                if(flutterResult != nil)
                {
                    flutterResult("Error");
                }
            } else {
                print("Error: \(result.error)")
                if(flutterResult != nil)
                {
                    flutterResult("Error");
                }
            }
        }
    }
    
    func purcharse(sku_id : String, flutterResult: @escaping FlutterResult)  {
        self.flutterResult = flutterResult;
        SwiftyStoreKit.purchaseProduct(sku_id, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                self.verifyReceipt(service: AppleReceiptValidator.VerifyReceiptURLType.production)
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                case .privacyAcknowledgementRequired:
                    print("privacyAcknowledgementRequired")
                case .unauthorizedRequestData:
                    print("unauthorizedRequestData")
                case .invalidOfferIdentifier:
                    print("invalidOfferIdentifier")
                case .invalidSignature:
                    print("invalidSignature")
                case .missingOfferParams:
                    print("missingOfferParams")
                case .invalidOfferPrice:
                    print("invalidOfferPrice")
                default:
                    print("others")
                }
                if(self.flutterResult != nil)
                {
                    self.flutterResult(false);
                }
            }
        }
    }
    
    func verify() -> Bool {
        //        let receipt = AppleReceiptValidator(service: .production)
        //        let password = "公共秘钥"
        //        SwiftyStoreKit.verifyReceipt(using: receipt, password: password, completion: { (result) in
        //            switch result {
        //            case .success(let receipt):
        //                print("receipt--->\(receipt)")
        //                break
        //            case .error(let error):
        //                print("error--->\(error)")
        //                break
        //            }
        //        })
        return true
    }
    
    
    func restore(flutterResult: @escaping FlutterResult) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                self.setHasBuy(hasBUy: false)
                if(flutterResult != nil)
                {
                    flutterResult(false)
                }
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                //                self.setHasBuy(hasBUy: true)
                //                results.restoredPurchases[0]
                
                var restltStr : String = ""
                
                for purchase in results.restoredPurchases {
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    
                    if(purchase.productId != nil)
                    {
                        if(restltStr.count > 0)
                        {
                            restltStr = "\(restltStr),\(purchase.productId)"
                        }else{
                            restltStr = purchase.productId
                        }
                    }
                    //                    purchase.productId
                    //                    guard purchase.productId == MyProducts.fullJulianDate.rawValue else { return }
                    //                    self.receiptHelper.importIAPsFromReceipt()
                    //                    self.restoreSuccessDelegate?.restoreSuccess()
                }
                if(flutterResult != nil)
                {
                    flutterResult(restltStr)
                }
            }
            else {
                print("Nothing to Restore")
                self.setHasBuy(hasBUy: false)
                if(flutterResult != nil)
                {
                    flutterResult(false)
                }
            }
        }
    }
    
    
    //    /// 购买商品
    //    class func purchase(productID: String,
    //                        inPurchaseClosure:@escaping ((_ inPurchaseResult: InPurchaseResult)->())) {
    //        SwiftyStoreKit.purchaseProduct(productID, quantity: 1, atomically: true) { (result) in
    //            switch result {
    //            case .success(let purchase):
    //                print("Purchase Success: \(purchase.productId)")
    //                // 正式验证
    //                self.verifyReceipt(service: .production)
    //                inPurchaseClosure(LFPayTool.InPurchaseResult.success)
    //            case .error(let error):
    //                inPurchaseClosure(LFPayTool.InPurchaseResult.failure)
    //                switch error.code {
    //                case .unknown:
    //                    print("Unknown error. Please contact support")
    //                case .clientInvalid:
    //                    print("Not allowed to make the payment")
    //                case .paymentCancelled:
    //                    break
    //                case .paymentInvalid:
    //                    print("The purchase identifier was invalid")
    //                case .paymentNotAllowed:
    //                    print("The device is not allowed to make the payment")
    //                case .storeProductNotAvailable:
    //                    print("The product is not available in the current storefront")
    //                case .cloudServicePermissionDenied:
    //                    print("Access to cloud service information is not allowed")
    //                case .cloudServiceNetworkConnectionFailed:
    //                    print("Could not connect to the network")
    //                case .cloudServiceRevoked:
    //                    print("User has revoked permission to use this cloud service")
    //                default:
    //                    print((error as NSError).localizedDescription)
    //                }
    //            }
    //        }
    //    }
    
    
    /// 本地验证（SwiftyStoreKit 已经写好的类） AppleReceiptValidator
    //  .production 苹果验证  .sandbox 本地验证
    func verifyReceipt(service: AppleReceiptValidator.VerifyReceiptURLType) {
        //let sharedSecret = ""
        let receiptValidator = AppleReceiptValidator(service: service, sharedSecret: nil)
        SwiftyStoreKit.verifyReceipt(using: receiptValidator) { (result) in
            switch result {
            case .success (let receipt):
                let status: Int = receipt["status"] as! Int
                if status == 21007 {
                    // sandbox验证
                    self.verifyReceipt(service: .sandbox)
                }
                if(self.flutterResult != nil)
                {
                    self.flutterResult(true);
                }
                self.setHasBuy(hasBUy: true)
                print("receipt：\(receipt)")
                break
            case .error(let error):
                print("error：\(error)")
                self.setHasBuy(hasBUy: false)
                if(self.flutterResult != nil)
                {
                    self.flutterResult(false);
                }
                break
            }
        }
    }
    
    func setHasBuy(hasBUy: Bool)  {
        self.isBuy = hasBUy;
    }
    
    func hasBuy() -> Bool {
        return isBuy
    }
}
