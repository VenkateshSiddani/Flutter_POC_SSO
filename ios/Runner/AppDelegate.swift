import UIKit
import Flutter
import IntuneMAMSwift
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let enrollmentDelegate = EnrollmentDelegateClass.init()
      let  policyDelegate = PolicyDelegateClass.init()
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
//    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
//    print("Flutter")
//    let primary =  IntuneMAMPolicyManager.instance().primaryUser;
//    print("\(String(describing: primary))")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
//    override func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//
//           //Set the delegate of the IntuneMAMPolicyManager to an instance of the PolicyDelegateClass
////           IntuneMAMPolicyManager.instance().delegate = self.policyDelegate
////        let primary =  IntuneMAMPolicyManager.instance().primaryUser;
////        print("\(String(describing: primary))")
//        IntuneMAMEnrollmentManager.instance().loginAndEnrollAccount(nil)
//
//        //Get the current user
////        let currentUser: String = IntuneMAMEnrollmentManager.instance().enrolledAccount() ?? ""
////        IntuneMAMEnrollmentManager.instance().deRegisterAndUnenrollAccount(currentUser, withWipe: true)
//
//
//           //Set the delegate of the IntuneMAMEnrollmentManager to an instance of the EnrollmentDelegateClass
////           IntuneMAMEnrollmentManager.instance().delegate = self.enrollmentDelegate
//
//           return true
//       }
        override func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            
//            IntuneMAMEnrollmentManager.instance().loginAndEnrollAccount(nil)
               return true
           }
}
