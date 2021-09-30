//
//  RewardAmob.swift
//  Runner
//
//  Created by ruifeng.yu on 2019/5/30.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

public class RewardAmob: NSObject,  GADFullScreenContentDelegate {
    
    var appId : String = Const.ADMOB_ID
    var rewardId : String = Const.ADMOB_VIDEO
    
    var controller : UIViewController!
    
    static let sharedInstance = RewardAmob()
    
    var result:  FlutterResult!
    
    var rewardedAd: GADRewardedAd?
    
    var hasEarnReward : Bool = false;
    
    func initReward(viewController:UIViewController) {
        self.controller = viewController
        
        
        self.rewardedAd = nil
        self.hasEarnReward = false
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: rewardId,
                           request: request, completionHandler: { (ad, error) in
                            if let error = error {
                                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                                
                                return
                            }
                            self.rewardedAd = ad
                            self.rewardedAd?.fullScreenContentDelegate = self
                           })
        
    }
    
    func showReard(viewController:UIViewController, result:  @escaping FlutterResult) -> Bool{
        self.controller = viewController
        
        self.result = result

        var isReady = false;
        
        if let ad = rewardedAd {
            isReady = true;
            ad.present(fromRootViewController: viewController,
                       userDidEarnRewardHandler: {
                        let reward = ad.adReward
                        self.hasEarnReward = true
                        // TODO: Reward the user.
                       })
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
    
    
    
    /// Tells the delegate that the ad failed to present full screen content.
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
        if(self.result != nil)
        {
            self.result(self.hasEarnReward)
        }
        self.initReward(viewController: controller)
    }
    
    /// Tells the delegate that the ad presented full screen content.
    public func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed.")
        if(self.result != nil)
        {
            self.result(self.hasEarnReward)
        }
        self.initReward(viewController: controller)
    }
    
    
    
}
