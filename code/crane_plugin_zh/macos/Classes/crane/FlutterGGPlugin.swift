//
//  FlutterGGPlugin.swift
//  Runner
//
//  Created by ruifeng.yu on 2019/6/16.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import StoreKit
import FlutterMacOS
let KEY = "flutter_gg";

open class FlutterGGPlugin: NSObject, FlutterStreamHandler{
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events;
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil;
    }
    
    
    
    private var eventSink : FlutterEventSink!
    
    fileprivate var eventChannel: FlutterEventChannel!
    
    //    var contoller : UIViewController!
    
    //    var ggView: GGView!
    
    static public func registerWith(registry:FlutterPluginRegistry
                                    //                             , viewController:UIViewController
    ) {
        
        
        //        if (registry.hasPlugin(KEY)) {return};
        let registrar = registry.registrar(forPlugin: KEY);
        
        
        let methodChannel = FlutterMethodChannel(name: KEY, binaryMessenger: registrar.messenger )
        
        
        let eventChannel = FlutterEventChannel(name: KEY, binaryMessenger: registrar.messenger )
        
        
        
        
        let plugin = FlutterGGPlugin(
            //            contoller: viewController
        )
        
        methodChannel.setMethodCallHandler({
            [plugin]
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            plugin.onMethodCall(call: call, result: result)
            
        })
        
        
    }
    
    
    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method
        let params = call.arguments as! NSDictionary
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
        case "showScoreView":
            if #available(macOS 10.14, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
            }
            
        case "showLeader":
            GameCenterHelper.helper.showLeader()
        case "reportScore":
            let iScore = params["score"] as! Int
            let rankId = params["rankId"] as! String
            GameCenterHelper.helper.reportScore(rankId: rankId, score: iScore)
            
        default:
//             result(FlutterMethodNotImplemented)
            result(false)

        }
        
    }
    
    
    func isZh() -> Bool {
        
        let defs = UserDefaults.standard
        
        let languages: [String] = defs.object(forKey: "AppleLanguages") as! [String]
        
        let prefrredLanguage = languages.first ?? "en"
        
        return String(prefrredLanguage).contains("zh")
    }
    
    
}
