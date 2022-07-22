import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    setUpMethodChannels(controller: controller)
      
      
//  let openFileChannel = FlutterMethodChannel(name: "com.example.ricoms_app/open_file",
//                                            binaryMessenger: controller.binaryMessenger)
//  openFileChannel.setMethodCallHandler({
//      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//
//      guard call.method == "openFile" else {
//        result(FlutterMethodNotImplemented)
//        return
//      }
//
//      if let args = call.arguments as? Dictionary<String, Any>,
//          let filePath = args["filePath"] as? String {
//          NSLog(filePath)
//
//          self?.openFile(filePath: filePath)
//        } else {
//          result(FlutterError.init(code: "bad args", message: nil, details: nil))
//          }
//  })
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


    private func setUpMethodChannels(controller: FlutterViewController) {
        
        let openFileChannel = FlutterMethodChannel(name: "com.example.ricoms_app/open_file",
                                                  binaryMessenger: controller.binaryMessenger)
        openFileChannel.setMethodCallHandler({
              (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
             
            guard call.method == "openFile" else {
                result(FlutterMethodNotImplemented)
                return
            }
            
            if let args = call.arguments as? Dictionary<String, Any>,
               let filePath = args["filePath"] as? String {
                NSLog(filePath)
                let url: URL = URL(string: "file:///var/mobile/Containers/Data/Application/26FE255F-C1B9-429F-84F6-E0D3C05FFE92/Documents/history_data_2022_07_22_10_22_47.csv")!
                let documentInteractionController = UIDocumentInteractionController(url: url)
                documentInteractionController.delegate = controller
                //let navigationController = UINavigationController(rootViewController: documentInteractionController)
                //self.window?.rootViewController?.present(navigationController, animated: true, completion: nil)
                //documentInteractionController.presentOpenInMenu(from: <#T##UIBarButtonItem#>, animated: <#T##Bool#>) .presentPreview(animated: true)

            } else {
              result(FlutterError.init(code: "bad args", message: nil, details: nil))
              }
            
            
            

            })
        }
}

extension FlutterViewController : UIDocumentInteractionControllerDelegate {
    
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }

    public func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView {
        return self.view
    }

    public func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return self.view.frame
    }
}

