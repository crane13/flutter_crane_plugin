import Cocoa
import FlutterMacOS
open class CraneAppDelegate: FlutterAppDelegate {

  open override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
//    FlutterGGPlugin.registerWith(registry: self)
    return true
  }
}
