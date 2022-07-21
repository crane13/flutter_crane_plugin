//
//  PopUtils_amob.swift
//  Runner
//
//  Created by ruifeng.yu on 2019/6/29.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

import UnityMediationSdk
class PopUtils_u: NSObject, UMSInterstitialAdLoadDelegate, UMSInterstitialAdShowDelegate{

    var interstitial: UMSInterstitialAd!
    private var controller: UIViewController?
    private var appId:String? = Const.U_ID
    private var posId:String? = Const.U_POP


    private var showNow : Bool = false
     static let sharedInstance = PopUtils_u()



    func loadAd(controller: UIViewController, now : Bool){

        self.showNow = now
        self.interstitial = UMSInterstitialAd.init(adUnitId: Const.U_POP)
        self.interstitial.load(with: self)


    }

    func showAd(controller: UIViewController, now : Bool)  -> Bool{
        self.controller = controller
        var shown = false

        if interstitial != nil {
            shown = true
            interstitial.show(with: controller, delegate: self)

        } else {
          self.loadAd(controller: controller, now : now)
        }
        return shown
    }



    func onInterstitialLoaded(_ interstitialAd: UMSInterstitialAd) {
        if(self.showNow){
            self.showNow = false
            self.showAd(controller: self.controller!, now : false)
        }

    }

    func onInterstitialFailedLoad(_ interstitialAd: UMSInterstitialAd, error: UMSLoadError, message: String) {

    }

    func onInterstitialShowed(_ interstitialAd: UMSInterstitialAd) {

    }

    func onInterstitialClicked(_ interstitialAd: UMSInterstitialAd) {

    }

    func onInterstitialClosed(_ interstitialAd: UMSInterstitialAd) {
        self.loadAd(controller: self.controller!, now : false)
    }

    func onInterstitialFailedShow(_ interstitialAd: UMSInterstitialAd, error: UMSShowError, message: String) {

    }




}
