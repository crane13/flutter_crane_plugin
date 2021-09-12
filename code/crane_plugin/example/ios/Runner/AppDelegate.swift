import UIKit
import Flutter
import crane_plugin


@UIApplicationMain
@objc class AppDelegate: CraneAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   
    self.initConfigs()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func initConfigs()  {
        Const.ADMOB_ID = "ca-app-pub-3940256099942544~1458002511"
        Const.ADMOB_BANNER = "ca-app-pub-3940256099942544/2934735716"
        Const.ADMOB_POP = "ca-app-pub-3940256099942544/4411468910"
        Const.ADMOB_VIDEO = "ca-app-pub-3940256099942544/1712485313"

    }
}
