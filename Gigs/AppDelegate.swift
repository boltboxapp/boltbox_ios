//
//  AppDelegate.swift
//  Gigs
//
//  Created by dreams on 20/12/17.
//  Copyright © 2017 dreams. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AMScrollingNavbar
import DrawerController
import netfox
import Stripe
import Braintree
import UserNotifications
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,OSSubscriptionObserver {

    var window: UIWindow?
    
    var drawerController: DrawerController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.sharedManager().enable = true
        //NFX.sharedInstance().start()
        
        IQKeyboardManager.sharedManager().disabledToolbarClasses = [GSChatDetailsViewController.self]
        IQKeyboardManager.sharedManager().disabledDistanceHandlingClasses = [GSChatDetailsViewController.self]
        IQKeyboardManager.sharedManager().disabledTouchResignedClasses = [GSChatDetailsViewController.self]
        
        // Stripe Publish Key
        Stripe.setDefaultPublishableKey("pk_test_Js15CigEZPZH69hjS2hgXjBx")
        // Paypal Key
//        PayPalMobile .initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "AfrBFVee3HnKZgWObWdp9kip7IQ3XzouSgzqkny3C_H2JFnhdePtuA9dWFKZJ9agd36GTxLKIA9ecPQz",
//                                                                PayPalEnvironmentSandbox: "AfrBFVee3HnKZgWObWdp9kip7IQ3XzouSgzqkny3C_H2JFnhdePtuA9dWFKZJ9agd36GTxLKIA9ecPQz"])
        
        if SESSION.isAppLaunchFirstTime() {
             loadIntroSceen()
        }
            
        else if (SESSION.isUserLogIn()) {
            loadHomeViewController()
        }
            
        else {
            loadLogInSceen()
        }
    
//        if SESSION.isUserLogInFirstTime() == false {
//
//            loadLogInSceen()
//        }
//
//        else if SESSION.isUserLogInFirstTime() == true {
//
//            loadIntroSceen()
//        }
//
//        else if (SESSION.isUserLogIn()) {
//
//            loadHomeViewController()
//        }
//
//        else {
//
//            loadLogInSceen()
//        }
      
//        loadHomeViewController()
        
//        // iOS 10 support
//        if #available(iOS 10, *) {
//            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
//            application.registerForRemoteNotifications()
//        }
//            // iOS 9 support
//        else if #available(iOS 9, *) {
//            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
//            UIApplication.shared.registerForRemoteNotifications()
//        }
//            // iOS 8 support
//        else if #available(iOS 8, *) {
//            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
//            UIApplication.shared.registerForRemoteNotifications()
//        }
//            // iOS 7 support
//        else {
//            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
//        }

        application.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        } else {
            // Fallback on earlier versions
        }
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "0cecfdf3-3e32-4071-8e41-6e391022e8cf",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        //        { notification in
        //            print("Received Notification - \(notification.payload.notificationID) - \(notification.payload.title)" as Any)
        //        }

        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })

        OneSignal.add(self as! OSSubscriptionObserver)

        return true
    }
    
    //OneSignal Notification
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")

        //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            SESSION.setDeviceId(aStrUserId: playerId)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        //UserDefaults.standard.set(token, forKey: DEVICE_TOKEN)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        guard let dict = userInfo["aps"]  as? [String: Any], let msg = dict ["alert"] as? String else {
            print("Notification Parsing Error")
            return
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.noData)
        
        
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
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func loadLogInSceen() {
        
        
        let loginViewController = GSLoginViewController(nibName: "GSLoginViewController", bundle: nil)

//        let loginViewController = GSViewController(nibName: "GSIntroScreenViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        
        changeRootViewController(aViewController: navigationController)

       // self.window?.rootViewController = navigationController
    }
    
    func loadIntroSceen() {
        
        let loginViewController = GSIntroScreenViewController(nibName: "GSIntroScreenViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        changeRootViewController(aViewController: navigationController)
 
    }

    func loadHomeViewController() {
        
        let aLeftViewController = GSLeftMenuViewController(nibName: "GSLeftMenuViewController", bundle: nil)
        let aNaviLeft = UINavigationController(rootViewController: aLeftViewController)
        
        let aCenterViewController = GSTabBarViewController(nibName: "GSTabBarViewController", bundle: nil)
        let aNaviCenter = UINavigationController(rootViewController: aCenterViewController)
        
        drawerController = DrawerController(centerViewController: aNaviCenter, leftDrawerViewController: aNaviLeft, rightDrawerViewController: nil)
        drawerController.showsShadows = true
        drawerController.openDrawerGestureModeMask = .all
        drawerController.closeDrawerGestureModeMask = .all
        
        changeRootViewController(aViewController: drawerController)

//        let loginViewCintroller = GSTabBarViewController()
//        let navigationController = UINavigationController(rootViewController: loginViewCintroller)
//        self.window?.rootViewController = navigationController
    }

    func changeRootViewController(aViewController: UIViewController) {
        if !(window!.rootViewController != nil) {
            window?.rootViewController = aViewController
            return
        }
        let snapShot: UIView? = window?.snapshotView(afterScreenUpdates: true)
        aViewController.view.addSubview(snapShot!)
        window?.rootViewController = aViewController
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            snapShot?.layer.opacity = 0
            snapShot?.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
        }, completion: {(_ finished: Bool) -> Void in
            snapShot?.removeFromSuperview()
        })
    }
}

