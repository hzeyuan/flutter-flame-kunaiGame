import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    self.setContentSize(NSSize(width: 480,height: 800))
    let window: NSWindow! = self.contentView?.window
    window.styleMask.remove(.resizable)


   
    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
