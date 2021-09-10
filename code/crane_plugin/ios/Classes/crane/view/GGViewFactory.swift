//
//  GGViewFactory.swift
//  Runner
//
//  Created by ruifeng.yu on 2019/6/16.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
let PluginKey = "plugins.crane.view/GGView";
public class GGViewFactory :  NSObject, FlutterPlatformViewFactory{
    var messenger: FlutterBinaryMessenger!
    var controller: UIViewController!
    
    @objc public init(messenger: (NSObject & FlutterBinaryMessenger)?, viewController: UIViewController) {
        super.init()
        self.messenger = messenger
        self.controller = viewController
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let uiActivityIndicatorController = GGView(withFrame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger, controller: controller)
//        uiActivityIndicatorController.loadAd(viewController: self.controller)
        
        return uiActivityIndicatorController
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    static func registerWith(registry:FlutterPluginRegistry, viewController:UIViewController) {
        
        
        if (registry.hasPlugin(PluginKey)) {return};
        let registrar = registry.registrar(forPlugin: PluginKey);
        
        let messenger = registrar?.messenger() as! (NSObject & FlutterBinaryMessenger)
        registrar?.register(GGViewFactory(messenger:messenger, viewController: viewController),withId: PluginKey);
        
    }
    

    
}
