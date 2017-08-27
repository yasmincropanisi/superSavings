//
//  AppDelegate.swift
//  TeenCard
//
//  Created by Gustavo De Mello Crivelli on 26/08/17.
//  Copyright © 2017 Gustavo De Mello Crivelli. All rights reserved.
//

import UIKit
import UserNotifications
import SafariServices

fileprivate let viewActionIdentifier = "VIEW_IDENTIFIER"
fileprivate let categoryIdentifier = "REQUEST"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        registerForPushNotifications()
        
        // Check if launched from notification
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {

            print("launched from push")
        }
        UNUserNotificationCenter.current().delegate = self
        return true
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

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            
            // 1
            let viewAction = UNNotificationAction(identifier: viewActionIdentifier,
                                                  title: "View",
                                                  options: [.foreground])
            
            // 2
            let requestCategory = UNNotificationCategory(identifier: categoryIdentifier,
                                                      actions: [viewAction],
                                                      intentIdentifiers: [],
                                                      options: [])
            // 3
            UNUserNotificationCenter.current().setNotificationCategories([requestCategory])
            
            self.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let aps = userInfo["aps"] as! [String: AnyObject]
        
        // Silent notification: update list of requests
        if aps["content-available"] as? Int == 1 {
            //let podcastStore = PodcastStore.sharedStore
            // Refresh Podcast
            // 2
//            podcastStore.refreshItems { didLoadNewItems in
//                // 3
//                completionHandler(didLoadNewItems ? .newData : .noData)
//            }
        } else  {
            // News
            // 4
//            _ = NewsItem.makeNewsItem(aps)
//            completionHandler(.newData)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // 1
        let userInfo = response.notification.request.content.userInfo
        let aps = userInfo["aps"] as! [String: AnyObject]
        
        // 2
        if let username = aps["username"] {

            if response.actionIdentifier == viewActionIdentifier {
//                let url = URL(string: newsItem as! String) {
//                let safari = SFSafariViewController(url: url)
//                window?.rootViewController?.present(safari, animated: true, completion: nil)
               let addUserVC = AddUserViewController()
               addUserVC.username = username as! String
               window?.rootViewController?.present(addUserVC, animated: true, completion: nil)
            }
        }
        
        // 4
        completionHandler()
    }
}
