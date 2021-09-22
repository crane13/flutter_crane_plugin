import Cocoa
import FlutterMacOS

class CraneFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    FlutterGGPlugin.registerWith(registry: flutterViewController)
    GameCenterHelper.helper.authenticateLocalPlayer(controller: flutterViewController);
    super.awakeFromNib()
  }
}
