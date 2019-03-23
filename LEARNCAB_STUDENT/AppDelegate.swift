//
//  AppDelegate.swift
//  LEARNCAB_STUDENT
//
//  Created by Exarcplus on 3/20/18.
//  Copyright © 2018 Exarcplus. All rights reserved.
//

import UIKit
import LGSideMenuController
import IQKeyboardManager
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


class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate, SirenDelegate {

    var window: UIWindow?
    var SideMenu:LGSideMenuController!
    var SideMenuView:SideMenuViewController!
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        var success: Bool
        do {
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient, mode: .default, options: [])
            success = true
        } catch let error as NSError {
            success = false
        }
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 28/255, green: 154/255, blue: 96/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -60), for:UIBarMetrics.default)
        UINavigationBar.appearance().isTranslucent = false
        
        //facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = "737980758579-5gonr77dckrp07e26m3i46rqohu09t46.apps.googleusercontent.com";
        
        let mainview = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        let nav = UINavigationController.init(rootViewController: mainview)
        SideMenu = LGSideMenuController.init(rootViewController: nav)
        SideMenu.setLeftViewEnabledWithWidth(240, presentationStyle: .slideAbove, alwaysVisibleOptions: [])
        SideMenuView = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        SideMenu.leftViewStatusBarVisibleOptions = .onAll
        SideMenu.leftViewStatusBarStyle = .lightContent
        var rect = SideMenuView.view.frame;
        rect.size.width = 240;
        SideMenuView.view.frame = rect
        SideMenu.leftView().addSubview(SideMenuView.view)
        
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            
            
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
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
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
         Siren.shared.checkVersion(checkType: .immediately)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Siren.shared.checkVersion(checkType: .daily)
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func setupSiren() {
        let siren = Siren.shared
        siren.delegate = self
        siren.debugEnabled = true
        
        siren.majorUpdateAlertType = .option
        siren.minorUpdateAlertType = .option
        siren.patchUpdateAlertType = .option
        siren.revisionUpdateAlertType = .option
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
            UserDefaults.standard.set(userInfo, forKey:"type")
            UserDefaults.standard.synchronize()
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            newDeviceId = refreshedToken
            print(newDeviceId)
            
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
    
    func sirenDidDetectNewVersionWithoutAlert(message: String) {
        print(#function, "\(message)")
    }
}
  
