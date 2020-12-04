//
//  AppDelegate.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 4/22/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import RealmSwift
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, GIDSignInDelegate {

    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]

//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .badge, .sound])
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == notificationID {
            print("notication has been handled")
        }
        completionHandler()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configNoticationCenter()
        // Config Firebase
        FirebaseApp.configure()
        // Config google signIn delegate
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 2) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
//        let realm = try! Realm()
        return true
    }
    
    // Config func for googleSignIn
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    
        let userInfo: GIDProfileData
        print("Pressed")
        
        NotificationCenter.default.post(name: Notification.Name("ProgressIndicatorDidStartNotification"), object: nil, userInfo: nil)

        if error != nil {
            if error.localizedDescription == "The user canceled the sign-in flow." {
                NotificationCenter.default.post(name: Notification.Name("ProgressIndicatorDidStopNotification"), object: nil, userInfo: nil)
                print("cancel btn toggled")
                return
            }
//            print("Email error: \(error.localizedDescription)")
        } else {
            
            guard let usersInfo = user.profile else { return }
            userInfo = usersInfo
            
            print("User email: \(userInfo.name ?? "N/A")")
            
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            
            // SignIn the user in the firebaseAuth
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("SignIn error \(error.localizedDescription)")
                    return
                }
                
                // Store userInfo in the Firebase DB
                guard let uid = authResult?.user.uid else { return }
                let db = Database.database().reference()
                let useRef = db.child("users")
                let newUserRef = useRef.child(uid)
                newUserRef.updateChildValues(["id": uid,
                                     "firstName": userInfo.givenName!,
                                     "lastName": userInfo.familyName!,
                                     "email": userInfo.email!,
                                     "password": "N/A",
                                     "profileImageUrl":  "\(userInfo.imageURL(withDimension: 100) ?? URL(fileURLWithPath: "N/A"))"])
                
                // SignIn observer
                NotificationCenter.default.post(name: Notification.Name("SuccessfulSignInNotification"), object: nil, userInfo: nil)
            }
        }


    }
    
    // Config func for googleSignIn
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func configNoticationCenter() {
        notificationCenter.delegate = self
        
        notificationCenter.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("error: \(String(describing: error?.localizedDescription))")
            }
        }
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
    }

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

