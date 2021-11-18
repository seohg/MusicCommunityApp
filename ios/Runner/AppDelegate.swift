import UIKit
import Flutter
import Firebase
import GoogleSignIn

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,GIDSignInDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    FirebaseApp.configure()
    GIDSignIn.sharedInstance()?.clientID = "com.googleusercontent.apps.833104939134-0dgjsd1qun447udhnp3fe5mifcupj620"
            GIDSignIn.sharedInstance()?.delegate = self
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
