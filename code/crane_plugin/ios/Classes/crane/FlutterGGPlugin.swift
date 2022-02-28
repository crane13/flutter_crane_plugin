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
    
    
    
    init( contoller : UIViewController!) {
        self.contoller = contoller
    }
    
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
        var successed: Bool = false;
        switch method {
        case "getPlatformVersion":
            var appVersion = ""
            let infoDictionary = Bundle.main.infoDictionary
            if let infoDictionary = infoDictionary {
                appVersion = infoDictionary["CFBundleShortVersionString"] as! String
            }
            result(appVersion)
        case "getPackageName":
           let bundleID = Bundle.main.bundleIdentifier
            result(bundleID)
        case "isPad":
            let isPad = Bool(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
            result(isPad)
            
        case "showScoreView":
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
                successed = true
            }
            result(successed)
        case "showLeader":
            GameCenterHelper.helper.showLeader()
            result(true)
        case "reportScore":
            let iScore = params["score"] as! Int
            let rankId = params["rankId"] as! String
            GameCenterHelper.helper.reportScore(rankId: rankId, score: iScore)
            result(true)
        case "isRewardVideoReady":
            result(self.isVideoReady())
        case "showBannerEnable":
            if self.ggView != nil{
                let view = self.ggView.view();
                if(view != nil)
                {
                    view.isHidden = !(params["showBanner"] as! Bool)
                    successed = true
                }
            }
            result(successed)
        case "showbanner":
            let admob_appid = Const.ADMOB_ID
            let admob_popid = Const.ADMOB_BANNER
            
            
            if self.ggView == nil{
                self.ggView = GGView()
            }
            self.ggView.setSize(size: "small")
            self.ggView.loadBanner(aid: admob_appid, abid: admob_popid, controller: contoller)
            
            let view = self.ggView.view();
            view.isHidden = false;
            let viewFrame : CGRect = contoller.view.frame
            
            
            view.frame = CGRect(x: (UIScreen.main.bounds.width - 320) / 2, y: viewFrame.height - 50, width: 320, height: 50)
            
            contoller.view.addSubview(view)
            result(true)
        case "showPopAd":
            let isNow = (params["isNow"] as! Bool)
            let isShown = PopUtils_amob.sharedInstance.showAd(controller: self.contoller, isNow: isNow)
            print("showPopAd \(isShown)")
            result(isShown)
            
        case "showRewardAd":
            self.showVideo(result: result)
        case "share":
            let content = (params["content"] as! String)
            let url = (params["url"] as! String)

            let shareUrl = URL(string: url)
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [content, shareUrl], applicationActivities: nil)
            contoller.present(activityViewController, animated: true, completion: nil)
             result(true)

        default:
            result(successed)
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
    
    
}
