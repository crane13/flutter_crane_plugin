import Cocoa
import FlutterMacOS

public class FlutterPluginIapPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_plugin_iap", binaryMessenger: registrar.messenger)
    let instance = FlutterPluginIapPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

   let method = call.method
          let params = call.arguments as! NSDictionary
          var successed: Bool = false;
          switch method {
          case "getPlatformVersion":
              result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
          case "initIAP":
              IAPUtils.sharedInstance.initIAP()
              result(successed)
          case "restore":
              IAPUtils.sharedInstance.restore(flutterResult: result)

          case "getSkuInfo":
              let sku_id = params["sku_id"]  as! String;
              IAPUtils.sharedInstance.getList(sku_id: sku_id, flutterResult:result)


          case "unlockScene":
              let sku_id = params["sku_id"]  as! String;
              IAPUtils.sharedInstance.purcharse(sku_id: sku_id, flutterResult:result)

          case "removeAds":
              result(successed)
          default:
               result(FlutterMethodNotImplemented)
          }
  }
}
