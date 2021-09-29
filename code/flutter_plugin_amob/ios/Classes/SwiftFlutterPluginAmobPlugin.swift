import Flutter
import UIKit

public class SwiftFlutterPluginAmobPlugin: NSObject, FlutterPlugin {
    
    private var eventSink : FlutterEventSink!
    
    fileprivate var eventChannel: FlutterEventChannel!
    
    var contoller : UIViewController!
    
    var ggView: GGView!
    
    init( contoller : UIViewController!) {
        self.contoller = contoller
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let controller : UIViewController =
        (UIApplication.shared.delegate?.window??.rootViewController)!;
        let channel = FlutterMethodChannel(name: "flutter_plugin_amob", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterPluginAmobPlugin(contoller: controller)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method
        
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
            
        case "isRewardVideoReady":
            result(self.isVideoReady())
        case "showBannerEnable":
            let params = call.arguments as! NSDictionary
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
            let isShown = PopUtils_amob.sharedInstance.showAd(controller: self.contoller)
            print("showPopAd \(isShown)")
            result(isShown)
            
        case "showRewardAd":
            self.showVideo(result: result)
            
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
