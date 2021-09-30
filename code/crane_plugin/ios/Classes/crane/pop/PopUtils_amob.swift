//
//  PopUtils_amob.swift
//  Runner
//
//  Created by ruifeng.yu on 2019/6/29.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import GoogleMobileAds
open class PopUtils_amob: NSObject, GADFullScreenContentDelegate{
    var interstitial: GADInterstitialAd!
    private var controller: UIViewController?
    private var appId:String? = Const.ADMOB_ID
    private var posId:String? = Const.ADMOB_POP
    
    static let sharedInstance = PopUtils_amob()
    
    func setAppAndPosdId(appId: String, posId:String){
        if appId != nil && appId.count > 0{
            self.appId = appId
        }
        if posId != nil && posId.count > 0{
            self.posId = posId
        }
    }
    
    func loadAd(controller: UIViewController, isNow : Bool){

        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:self.posId!,
                               request: request,
                               completionHandler: { (ad, error) in
                                if let error = error {
                                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                    return
                                }
                                self.interstitial = ad
                                self.interstitial.fullScreenContentDelegate = self
                                if(isNow)
                                {
                                    self.showAd(controller: controller, isNow : false)
                                }
                               })
    }
    
    func showAd(controller: UIViewController, isNow : Bool)  -> Bool{
        self.controller = controller
        var shown = false
        if let ad = interstitial {
            shown = true
            ad.present(fromRootViewController: controller)
        } else {
            self.loadAd(controller: controller, isNow : isNow)
        }
        return shown
    }
    
    public func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }
    
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad failed to present full screen content with error \(error.localizedDescription).")
    }
    
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        self.loadAd(controller: self.controller!, isNow: false)
    }
    
    
    
}
