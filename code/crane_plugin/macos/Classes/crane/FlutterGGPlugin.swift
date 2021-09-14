//
//  FlutterGGPlugin.swift
//  Runner
//
//  Created by ruifeng.yu on 2019/6/16.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import StoreKit
let KEY = "flutter_gg";

class FlutterGGPlugin: NSObject, FlutterStreamHandler{
    
    private var eventSink : FlutterEventSink!
    
    fileprivate var eventChannel: FlutterEventChannel!
    
    var contoller : UIViewController!
    
    var ggView: GGView!
    
    static func registerWith(registry:FlutterPluginRegistry, viewController:UIViewController) {
        
        
        if (registry.hasPlugin(KEY)) {return};
        let registrar = registry.registrar(forPlugin: KEY);
        
        
        let methodChannel = FlutterMethodChannel(name: KEY, binaryMessenger: registrar?.messenger() as! FlutterBinaryMessenger)
        
        
        let eventChannel = FlutterEventChannel(name: KEY, binaryMessenger: registrar?.messenger() as! FlutterBinaryMessenger)
        
        
        
        
        let plugin = FlutterGGPlugin(contoller: viewController)
        
        methodChannel.setMethodCallHandler({
            [plugin]
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            plugin.onMethodCall(call: call, result: result)
            
        })
        
        
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events;
        return nil;
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil;
    }
    
    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method
        let params = call.arguments as! NSDictionary
        
        if method == "getPlatformVersion" {
            var appVersion = ""
            let infoDictionary = Bundle.main.infoDictionary
            if let infoDictionary = infoDictionary {
                appVersion = infoDictionary["CFBundleShortVersionString"] as! String
                //                let appBuild = infoDictionary["CFBundleVersion"]
                //                PrintLog("version\(appVersion),build\(appBuild)")
            }
            
            //            print("version\(appVersion)")
            result(appVersion)
        }else if method == "showScoreView"{
                   if #available(iOS 10.3, *) {
                       SKStoreReviewController.requestReview()
                   }

        }else if method == "unlockScene"{
            
        }else if method == "removeAds"{
        }else if method == "showLeader"{
            GameCenterHelper.helper.showLeader()
        }else if method == "reportScore"{
            let iScore = params["score"] as! Int
            let rankId = params["rankId"] as! String
            GameCenterHelper.helper.reportScore(rankId: rankId, score: iScore)
            // result(RewardAmob.sharedInstance.isReady(viewController: self.contoller))
            // result(RewardAmob.sharedInstance.isReady(viewController: self.contoller))
        }else if method == "isRewardVideoReady"{
            
            result(self.isVideoReady())
            // result(RewardAmob.sharedInstance.isReady(viewController: self.contoller))
            
        }else if method == "isPad" {
            let isPad = Bool(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
            result(isPad)
        } else if method == "registerSid" {
            let sid = params["sid"] as! String
            if(sid != nil && sid.count > 0)
            {
                UserDefaults.standard.set(sid, forKey: "sid")
            }
        }else if method == "showBannerEnable" {
            if self.ggView != nil{
                let view = self.ggView.view();
                if(view != nil)
                {
                    view.isHidden = !(params["showBanner"] as! Bool)
                }
            }
        }else if method == "registerAdmobId" {
            
        }else if method == "showbanner"{
            let admob_appid = Const.ADMOB_ID
            let admob_popid = Const.ADMOB_BANNER
        
            
            if self.ggView == nil{
                self.ggView = GGView()
            }
            self.ggView.setSize(size: "small")
            self.ggView.loadBanner(aid: admob_appid, abid: admob_popid, controller: contoller)
            
            let view = self.ggView.view();
            view.isHidden = false;
            var viewFrame : CGRect = contoller.view.frame
            
            
            //            viewFrame.origin.y = viewFrame.height - 60
            
     //       view.frame = CGRect(x: 0, y: viewFrame.height - 50, width: UIScreen.main.bounds.width, height: 50)

              view.frame = CGRect(x: (UIScreen.main.bounds.width - 320) / 2, y: viewFrame.height - 50, width: 320, height: 50)

            //            view.frame = viewFrame
            contoller.view.addSubview(view)
            
            //            self.showbanner()
            
        }else if method == "showPopAd"{
            
            var isShown = PopUtils_amob.sharedInstance.showAd(controller: self.contoller)
            print("showPopAd \(isShown)")
            result(isShown)
            
            
            
        }else if method == "showRewardAd"{
            self.showVideo(result: result)
        }else{
            
        }
    }
    
    func isVideoReady() -> Bool {
        
        
//        let readyGDT : Bool = RewardGDT.sharedInstance.isReady(viewController: self.contoller);
        
        let readyMob : Bool = RewardAmob.sharedInstance.isReady(viewController: self.contoller);
        
        let readyGDT : Bool = false
        
//        print(readyMob)
        print("readyMob \(readyMob)")
        return readyGDT || readyMob
    }
    
    func showVideo(result:  @escaping FlutterResult)
    {
        if(self.isZh())
        {
//            if(RewardGDT.sharedInstance.isReady(viewController: self.contoller))
//            {
//                RewardGDT.sharedInstance.showReard(viewController: self.contoller, appId: Const.GDT_ID, rewardId: Const.GDT_VIDEO, result: result)
//            }else
                if(RewardAmob.sharedInstance.isReady(viewController: self.contoller))
            {
                RewardAmob.sharedInstance.showReard(viewController: self.contoller,  result: result)
            }
        }else{
            if(RewardAmob.sharedInstance.isReady(viewController: self.contoller))
            {
                RewardAmob.sharedInstance.showReard(viewController: self.contoller,  result: result)
            }
//            else if(RewardGDT.sharedInstance.isReady(viewController: self.contoller))
//            {
//                RewardGDT.sharedInstance.showReard(viewController: self.contoller, appId: Const.GDT_ID, rewardId: Const.GDT_VIDEO, result: result)
//            }
        }
        
    }
    
    
    
    func isZh() -> Bool {
        
        let defs = UserDefaults.standard
        
        let languages: [String] = defs.object(forKey: "AppleLanguages") as! [String]
        
        let prefrredLanguage = languages.first ?? "en"
        
        return String(prefrredLanguage).contains("zh")
    }
    
    
    
    init( contoller : UIViewController!) {
        //        super.init()
        self.contoller = contoller
    }
    
    //    func showAny(position: Int)  {
    //        let mainController = self.contoller as! MainViewController
    //        mainController.showAd(position)
    //    }
    //    func showbanner()  {
    //        let mainController = self.contoller as! MainViewController
    //        mainController.showAd(1)
    //    }
    //    func showPop()  {
    //        let mainController = self.contoller as! MainViewController
    //        mainController.showAd(2)
    //    }
    //    func showVideo()  {
    //        let mainController = self.contoller as! MainViewController
    //        mainController.showAd(5)
    //    }
    //
    //    func isVideoRedy() -> Bool  {
    //        let mainController = self.contoller as! MainViewController
    //        return mainController.isVideoReady() == 1;
    //    }
}
