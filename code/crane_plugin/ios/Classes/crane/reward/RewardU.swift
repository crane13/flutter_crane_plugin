//
//  RewardAmob.swift
//  Runner
//
//  Created by ruifeng.yu on 2019/5/30.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import UIKit

import UnityMediationSdk

public class RewardU: NSObject, UMSRewardedAdLoadDelegate, UMSRewardedAdShowDelegate {

    
  
    
    var appId : String = Const.U_ID
    var rewardId : String = Const.U_VIDEO
    
    var controller : UIViewController!
    
    static let sharedInstance = RewardU()
    
    var result:  FlutterResult!
    
    var rewardedAd: UMSRewardedAd?
    
    var hasEarnReward : Bool = false;
    
    //    var
    func initReward(viewController:UIViewController) {
        self.controller = viewController
        
        
        self.rewardedAd = nil
        self.hasEarnReward = false
        
        self.rewardedAd = UMSRewardedAd.init(adUnitId: Const.U_VIDEO)
        self.rewardedAd?.load(with: self)
        
//        let request = GADRequest()
//        GADRewardedAd.load(withAdUnitID: rewardId,
//                           request: request, completionHandler: { (ad, error) in
//                            if let error = error {
//                                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
//
//                                return
//                            }
//                            self.rewardedAd = ad
//                            self.rewardedAd?.fullScreenContentDelegate = self
//                           })
        
    }
    
    func showReard(viewController:UIViewController, result:  @escaping FlutterResult) -> Bool{
        self.controller = viewController
        
        self.result = result
      
        
        var isReady = false;
        
        
        
        if rewardedAd != nil {
            isReady = true;
            
            rewardedAd?.show(with: viewController, delegate: self)
            
        } else {
            self.initReward(viewController: viewController)
        }
        return isReady;
    }
    
    public func isReady(viewController:UIViewController) -> Bool
    {
        let isReady = self.rewardedAd != nil
        if(!isReady)
        {
            initReward(viewController: viewController)
        }
        return isReady
    }
    
    public func onRewardedLoaded(_ rewardedAd: UMSRewardedAd) {
        
    }
    
    public func onRewardedFailedLoad(_ rewardedAd: UMSRewardedAd, error: UMSLoadError, message: String) {
        
    }
    
    public func onRewardedShowed(_ rewardedAd: UMSRewardedAd) {
        
    }
    
    public func onRewardedClicked(_ rewardedAd: UMSRewardedAd) {
        
    }
    
    public func onRewardedClosed(_ rewardedAd: UMSRewardedAd) {
        if(self.result != nil)
        {
            self.result(self.hasEarnReward)
        }
        self.initReward(viewController: controller)
    }
    
    public func onRewardedFailedShow(_ rewardedAd: UMSRewardedAd, error: UMSShowError, message: String) {
        if(self.result != nil)
        {
            self.result(self.hasEarnReward)
        }
        self.initReward(viewController: controller)
    }
    
    public func onUserRewarded(_ rewardedAd: UMSRewardedAd, reward: UMSReward) {
        self.hasEarnReward = true
    }
    
}
