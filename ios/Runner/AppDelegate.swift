import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
  let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
  let openFileChannel = FlutterMethodChannel(name: "com.example.ricoms_app/open_file",
                                            binaryMessenger: controller.binaryMessenger)
  openFileChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      
      guard call.method == "openFile" else {
        result(FlutterMethodNotImplemented)
        return
      }

      if let args = call.arguments as? Dictionary<String, Any>,
          let filePath = args["filePath"] as? String {
          NSLog(filePath)

          self?.openFile(filePath: filePath)
        } else {
          result(FlutterError.init(code: "bad args", message: nil, details: nil))
          }
  })
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


    private func openFile(filePath: String) {
        if let url = URL(string: filePath) {
                if #available(iOS 10, *){
                    UIApplication.shared.open(url)
                }else{
                    UIApplication.shared.openURL(url)
                }

        }
    }
}
