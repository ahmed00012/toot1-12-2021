
import UIKit
import Flutter
import Firebase
import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        GMSServices.provideAPIKey("AIzaSyB5BcV87jM6r0ZYGDvuqX0kksLy0LhVvRo")
//      [GMSServices, provideAPIKey:@"AIzaSyB5BcV87jM6r0ZYGDvuqX0kksLy0LhVvRo"],
      FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
