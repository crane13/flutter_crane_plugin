import UIKit
import Flutter
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport
import UnityMediationSdk

let kOverlayStyleUpdateNotificationName = "io.flutter.plugin.platform.SystemChromeOverlayNotificationName"
let kOverlayStyleUpdateNotificationKey = "io.flutter.plugin.platform.SystemChromeOverlayNotificationKey"
open class CraneAppDelegate: FlutterAppDelegate, UMSInitializationDelegate, AppOpenAdManagerDelegate{
    var canShowSplash: Bool = true
    
    open override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if(self.isFireEnable())
        {
            FireBaseUtils.sharedInstance.initFirebase()
        }
        self.initOther()
        
        let controller: FlutterViewController = window.rootViewController as! FlutterViewController
        
        GGViewFactory.registerWith(registry: self, viewController: controller)
        
        GameCenterHelper.helper.authenticateLocalPlayer(controller: controller);
        
        FlutterGGPlugin.registerWith(registry: self, viewController: controller)
        
        self.canShowSplash = self.shouldSplash()
        
        if(self.canShowSplash){
            
            AppOpenAdManager.shared.appOpenAdManagerDelegate = self
            AppOpenAdManager.shared.loadAd()
        }
        
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    open override func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return (UIInterfaceOrientationMask.portrait);
    }
    
    
    open func isFireEnable() -> Bool{
        return true
    }
    public func isIphoneX() -> Bool {
        return UIScreen.main.nativeBounds.size.height - 2436 == 0 ? true : false
    }
    
    public func isSmallIphone() -> Bool {
        return UIScreen.main.bounds.size.height == 480 ? true : false
    }
    
    open override func applicationDidBecomeActive(_ application: UIApplication)
    {
        // 2.timer(必须在主线程中执行)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.requestIDFA), userInfo: nil, repeats: false)
        
        if(self.canShowSplash){
            let rootViewController = application.windows.first(
                where: { $0.isKeyWindow })?.rootViewController
            if let rootViewController = rootViewController {
                // Do not show app open ad if the current view controller is SplashViewController.
                
                AppOpenAdManager.shared.showAdIfAvailable(viewController: rootViewController)
            }
        }
        //      self.requestIDFA()
    }
    
    @objc func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // Tracking authorization completed. Start loading ads here.
                // loadAd()
                //                self.initOther()
            })
        } else {
            // Fallback on earlier versions
            //            self.initOther()
        }
    }
    
    func initOther(){
        //     GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        let builder = UMSInitializationConfigurationBuilder.init();
        let config = builder.setGameId(Const.U_ID).setInitializationDelegate(self).build()
        UMSUnityMediation.initialize(with: config)
        //        UnityMediation.Initialize()
        //        UMSUnityMediation.init()
    }
    
    public func onInitializationComplete() {
        
    }
    
    public func onInitializationFailed(_ errorCode: UMSSdkInitializationError, message: String!) {
        
    }
    
    func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager){
        
    }
    
    func shouldSplash() -> Bool {
        
        let userDefault = UserDefaults.standard
        let KEY_FIRST = "first_time"
        var intValue: Int = userDefault.integer(forKey: KEY_FIRST)
        if(intValue == nil){
            intValue = 0
        }
        if(intValue > 10){
            let duration = Int(Date().timeIntervalSince1970) - intValue
            if(duration > 1 * 24 * 60 * 60){
                return true
            }
        }else{
            userDefault.set(Int(Date().timeIntervalSince1970), forKey: KEY_FIRST)
        }

        return false
        
        //                 return true
    }
}

// extension FlutterViewController {
//
//     private struct StatusBarStyleHolder {
//         static var style: UIStatusBarStyle = .default
//     }
//
//     open override func viewDidLoad() {
//         super.viewDidLoad()
//
//         NotificationCenter.default.addObserver(
//             self,
//             selector: #selector(appStatusBar(notification:)),
//             name: NSNotification.Name(kOverlayStyleUpdateNotificationName),
//             object: nil
//         )
//     }
//
//     open override var preferredStatusBarStyle: UIStatusBarStyle {
//         return StatusBarStyleHolder.style
//     }
//
//     @objc private func appStatusBar(notification: NSNotification) {
//         guard
//             let info = notification.userInfo as? Dictionary<String, Any>,
//             let statusBarStyleKey = info[kOverlayStyleUpdateNotificationKey] as? Int
//         else {
//             return
//         }
//
//         if #available(iOS 13.0, *) {
//             StatusBarStyleHolder.style = statusBarStyleKey == 0 ? .darkContent : .lightContent
//         } else {
//             StatusBarStyleHolder.style = statusBarStyleKey == 0 ? .default : .lightContent
//         }
//
//         setNeedsStatusBarAppearanceUpdate()
//     }
// }
