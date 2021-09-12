import UIKit
import Flutter
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport
let kOverlayStyleUpdateNotificationName = "io.flutter.plugin.platform.SystemChromeOverlayNotificationName"
let kOverlayStyleUpdateNotificationKey = "io.flutter.plugin.platform.SystemChromeOverlayNotificationKey"
open class CraneAppDelegate: FlutterAppDelegate {
    open override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.requestIDFA()
       FireBaseUtils.sharedInstance.initFirebase()
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        let controller: FlutterViewController = window.rootViewController as! FlutterViewController

        GGViewFactory.registerWith(registry: self, viewController: controller)

        GameCenterHelper.helper.authenticateLocalPlayer(controller: controller);

        FlutterGGPlugin.registerWith(registry: self, viewController: controller)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    open override func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return (UIInterfaceOrientationMask.portrait);
    }

    public func isIphoneX() -> Bool {
        return UIScreen.main.nativeBounds.size.height - 2436 == 0 ? true : false
    }

    public func isSmallIphone() -> Bool {
        return UIScreen.main.bounds.size.height == 480 ? true : false
    }

    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // Tracking authorization completed. Start loading ads here.
                // loadAd()
            })
        } else {
            // Fallback on earlier versions
        }
    }
}

//extension FlutterViewController {
//
//    private struct StatusBarStyleHolder {
//        static var style: UIStatusBarStyle = .default
//    }
//
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(appStatusBar(notification:)),
//            name: NSNotification.Name(kOverlayStyleUpdateNotificationName),
//            object: nil
//        )
//    }
//
//    open override var preferredStatusBarStyle: UIStatusBarStyle {
//        return StatusBarStyleHolder.style
//    }
//
//    @objc private func appStatusBar(notification: NSNotification) {
//        guard
//            let info = notification.userInfo as? Dictionary<String, Any>,
//            let statusBarStyleKey = info[kOverlayStyleUpdateNotificationKey] as? Int
//        else {
//            return
//        }
//
//        if #available(iOS 13.0, *) {
//            StatusBarStyleHolder.style = statusBarStyleKey == 0 ? .darkContent : .lightContent
//        } else {
//            StatusBarStyleHolder.style = statusBarStyleKey == 0 ? .default : .lightContent
//        }
//
//        setNeedsStatusBarAppearanceUpdate()
//    }
//}