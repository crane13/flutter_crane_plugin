import Foundation
import GoogleMobileAds
import AppTrackingTransparency
open class CraneAmob{
    public static func initAmob(registry: FlutterPluginRegistry,
                            viewController:UIViewController )
    {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        GGViewFactory.registerWith(registry: registry, viewController: viewController)
        
        self.requestIDFA()
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
