//
//  AppDelegate.swift
//  Notee
//
//  Created by VTS-ThangTV28 on 15/07/2021.
//

import UIKit
import UserNotifications
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var appCoodinator: AppCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow.init(frame:  UIScreen.main.bounds)
        
        appCoodinator = AppCoordinator(window: window)
        appCoodinator?.start()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, Error in
            Logger("UNUserNotificationCenter", "\(granted)")
        }
        UNUserNotificationCenter.current().delegate = self

        
        Logger("path Realm", Realm.Configuration.defaultConfiguration.fileURL!)
        
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}

