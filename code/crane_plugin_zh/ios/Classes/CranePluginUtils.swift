import Foundation
import GoogleMobileAds
import AppTrackingTransparency
open class CranePluginUtils{
    public static func initCrane(registry: FlutterPluginRegistry,
                            viewController:UIViewController )
    {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        GGViewFactory.registerWith(registry: registry, viewController: viewController)
        
        self.requestIDFA()



         FireBaseUtils.sharedInstance.initFirebase()

    }
    
    static  func  requestIDFA() {
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
