//
//  GGView.swift
//  Runner
//
//  Created by ruifeng.yu on 2019/6/16.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter
import UIKit

import GoogleMobileAds



public class GGView : NSObject, FlutterPlatformView, FlutterStreamHandler, GADBannerViewDelegate{
    
    fileprivate var methodChannel: FlutterMethodChannel!
    fileprivate var eventChannel: FlutterEventChannel!
    private var adView: GADBannerView!
    
    
    var events : FlutterEventSink!
    
    private var event : NSString!

    private var admob_appId :String! = Const.ADMOB_ID
    private var admob_bannerId :String! = Const.ADMOB_BANNER
    
    private var isGDT = false
    private var size: String!
    
    public override init() {
        super.init()
    }
    
    @objc public init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger: FlutterBinaryMessenger, controller: UIViewController) {
        
        super.init()
        
        let params = args as! NSDictionary
        self.size = params["size"] as? String
        
        
        self.loadBanner(aid: admob_appId, abid: admob_bannerId,  controller: controller)
        
        self.methodChannel = FlutterMethodChannel(name: PluginKey, binaryMessenger: binaryMessenger)
        
        self.eventChannel = FlutterEventChannel(name: PluginKey, binaryMessenger: binaryMessenger)
        
        self.eventChannel.setStreamHandler(self)
        
        
        
        
        self.methodChannel.setMethodCallHandler({
            [weak self]
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if let this = self {
                this.onMethodCall(call: call, result: result)
            }
        })
        
        
        
    }
    
    
    func loadBanner(aid: String, abid: String, controller:UIViewController) {
            if self.adView != nil{
                self.adView.delegate = nil
                self.adView.removeFromSuperview()
                self.adView = nil
            }
            
            if(self.isLarge())
            {
                self.adView = GADBannerView(adSize: GADAdSizeMediumRectangle)

                
                
            }else{
                self.adView = GADBannerView(adSize: GADAdSizeBanner)
            }
            
            self.adView.adUnitID = self.admob_bannerId
  
            self.adView.rootViewController = controller
            self.adView.delegate = self

            
            self.adView.load(GADRequest())
        
    }
    
    func destroy(){
        if self.adView != nil{
            self.adView.delegate = nil
            self.adView.removeFromSuperview()
            self.adView = nil
        }
       
    }
    
    
    private func isLarge() -> Bool
    {
        return "large" == self.size
    }
    
    public func setSize(size: String)
    {
        self.size = size
    }
    
    
    
    public func view() -> UIView {
        
            return self.adView
       
    }
    
  
    func isZh() -> Bool {
        
        let defs = UserDefaults.standard
        
        let languages: [String] = defs.object(forKey: "AppleLanguages") as! [String]
        
        let prefrredLanguage = languages.first ?? "en"
        
        return String(prefrredLanguage).contains("zh")
    }
    
    
    private func onEventGDT(event : String) {
        
        if event.count > 0
        {
            if(!event.contains("GDT_banner_"))
            {
                let finalEvent = "GDT_banner_" + event
                
                self.onEvent(event: finalEvent)
            }
        }
    }
    
    private func onEventAdmob(event : String) {
        print("onEventAdmob \(event)")
        
        if event.count > 0
        {
            if(!event.contains("Admob_banner_"))
            {
                let finalEvent = "Admob_banner_" + event
                
                self.onEvent(event: finalEvent)
            }
        }
    }
    
    private func onEvent(event : String) {
        if event.count > 0
        {
            if(self.events != nil)
            {
                self.events(event)
            }
        }
    }
    
    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method
        if method == "start" {
            //            self.indicator.startAnimating()
        } else if method == "stop" {
            //            self.indicator.stopAnimating()
        }
    }
    
    
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        
        self.events = events;
        
        
        return nil;
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil;
    }
    
    
    public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
    }

    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    public func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    public func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    public func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    public func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}
