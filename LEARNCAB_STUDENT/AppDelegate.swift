//
//  AppDelegate.swift
//  LEARNCAB_STUDENT
//
//  Created by Exarcplus on 3/20/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import LGSideMenuController
import IQKeyboardManagerSwift
import AFNetworking
import FBSDKLoginKit
import GoogleSignIn
import Firebase
import FirebaseInstanceID
import FirebaseCrash
import AVFoundation
import UserNotifications
import Siren
var newDeviceId = ""

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate,UNUserNotificationCenterDelegate,SirenDelegate {

    var window: UIWindow?
    var SideMenu:LGSideMenuController!
    var SideMenuView:SideMenuViewController!
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
//        IQKeyboardManager.sharedManager().enable = true
//        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
//        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        var success: Bool
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            success = true
        } catch let error as NSError {
          //  categoryError = error
            success = false
        }
        
        if !success {
            //print("AppDelegate Debug - Error setting AVAudioSession category.  Because of this, there may be no sound. \(categoryError!)")
        }
        UINavigationBar.appearance().barTintColor = UIColor(red: 28/255, green: 154/255, blue: 96/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
        UINavigationBar.appearance().isTranslucent = false
        
        
        
        //facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = "737980758579-5gonr77dckrp07e26m3i46rqohu09t46.apps.googleusercontent.com";
        
        let mainview = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        let nav = UINavigationController.init(rootViewController: mainview)
        SideMenu = LGSideMenuController.init(rootViewController: nav)
        SideMenu.setLeftViewEnabledWithWidth(240, presentationStyle: .slideAbove, alwaysVisibleOptions: [])
        //        SideMenu.setRightViewEnabledWithWidth(280, presentationStyle:.slideAbove, alwaysVisibleOptions:[])
        SideMenuView = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        SideMenu.leftViewStatusBarVisibleOptions = .onAll
        SideMenu.leftViewStatusBarStyle = .lightContent
        //SideMenu.isLeftViewHidesOnTouch = true
        //        SideMenuView.selectedpage = 0;
        var rect = SideMenuView.view.frame;
        rect.size.width = 240;
        SideMenuView.view.frame = rect
        SideMenu.leftView().addSubview(SideMenuView.view)
        //SideMenu.leftView().addSubview(SideMenuView.view)
        
    //Firebase Connection
        FirebaseApp.configure()
        
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        setupSiren()
        return true
    }
    
    var orientationLock = UIInterfaceOrientationMask.portrait
    var myOrientation: UIInterfaceOrientationMask = .portrait
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return myOrientation
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
         Siren.shared.checkVersion(checkType: .immediately)
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Siren.shared.checkVersion(checkType: .daily)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setupSiren() {
        let siren = Siren.shared
        // Optional
        siren.delegate = self
        // Optional
        siren.debugEnabled = true
        
        siren.majorUpdateAlertType = .option
        siren.minorUpdateAlertType = .option
        siren.patchUpdateAlertType = .option
        siren.revisionUpdateAlertType = .option
        
    }
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        if let refreshedToken = InstanceID.instanceID().token() {
//            print("InstanceID token: \(refreshedToken)")
//            newDeviceId = refreshedToken
//            print(newDeviceId)
//            //default.set(refreshedToken, forKey: Constant.UserDefaults.token)
//
//            //Messaging.messaging().apnsToken = deviceToken
//
//            print("Token generated: ", refreshedToken)
//        }
//        UserDefaults.standard.set(newDeviceId, forKey:"token")
//        UserDefaults.standard.synchronize()
//        let devicetoken : String!
//        devicetoken = UserDefaults.standard.string(forKey:"token") as String?
//        print(devicetoken)
//        //connectToFcm()
//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
            UserDefaults.standard.set(userInfo, forKey:"type")
            UserDefaults.standard.synchronize()
            //messageType = messageID
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            newDeviceId = refreshedToken
            print(newDeviceId)
            //default.set(refreshedToken, forKey: Constant.UserDefaults.token)
            
            Messaging.messaging().apnsToken = deviceToken
            
            print("Token generated: ", refreshedToken)
        }
        UserDefaults.standard.set(newDeviceId, forKey:"token")
        UserDefaults.standard.synchronize()
        let devicetoken : String!
        devicetoken = UserDefaults.standard.string(forKey:"token") as String?
        print(devicetoken)
        connectToFcm()
    }
    func connectToFcm() {
        //Messaging.messaging().shouldEstablishDirectChannel = true
        fcmConnectionStateChange()
    }
    
    func fcmConnectionStateChange() {
        if Messaging.messaging().isDirectChannelEstablished {
            print("Connected to FCM.")
        } else {
            print("Disconnected from FCM.")
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
        
        
    }
    
    func sirenDidShowUpdateDialog(alertType: Siren.AlertType) {
        print(#function, alertType)
    }
    
    func sirenUserDidCancel() {
        print(#function)
    }
    
    func sirenUserDidSkipVersion() {
        print(#function)
    }
    
    func sirenUserDidLaunchAppStore() {
        print(#function)
    }
    
    func sirenDidFailVersionCheck(error: NSError) {
        print(#function, error)
    }
    
    func sirenLatestVersionInstalled() {
        print(#function, "Latest version of app is installed")
    }
    
    // This delegate method is only hit when alertType is initialized to .none
    func sirenDidDetectNewVersionWithoutAlert(message: String) {
        print(#function, "\(message)")
    }
}
  
