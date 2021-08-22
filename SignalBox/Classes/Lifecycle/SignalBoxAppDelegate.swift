//
//  SignalBoxAppDelegate.swift
//  SignalBox
//
//  Created by jimmy on 2021/8/20.
//

import Foundation
import CloudKit


///用于App级别的消息转发, 保证module拥有App完整地生命周期
open class SignalBoxAppDelegate: UIResponder, UIApplicationDelegate {
    
    open override func remoteControlReceived(with event: UIEvent?) {
        SignalBox.shared.remoteControlReceived(with: event)
    }
    
    @discardableResult open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        SignalBox.shared.moduleOpen(launchOptions: launchOptions)
        return true
    }
    
    open func applicationDidBecomeActive(_ application: UIApplication) {
        SignalBox.shared.moduleDidBecomeActive()
    }
    
    open func applicationWillResignActive(_ application: UIApplication) {
        SignalBox.shared.moduleWillResignActive()
    }
    
    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        SignalBox.shared.moduleOpenURL(url: url, options: options)
        return true
    }
    
    open func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        SignalBox.shared.moduleDidReceiveMemoryWarning()
    }
    
    
    open func applicationWillTerminate(_ application: UIApplication) {
        SignalBox.shared.moduleWillTerminate()
    }
    
    open func applicationSignificantTimeChange(_ application: UIApplication) {
        SignalBox.shared.moduleSignificantTimeChange()
    }
    
    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SignalBox.shared.moduleDidRegister(remoteNotificationsWithDeviceToken: deviceToken)
    }
    
    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        SignalBox.shared.moduleDidFailToRegister(remoteNotificationsWithError: error)
    }
    
    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        SignalBox.shared.moduleDidReceiveRemoteNotification(userInfo: userInfo, fetchCompletionHandler: completionHandler)
    }
    
    open func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        SignalBox.shared.modulePerformAction(shortcutItem: shortcutItem, completionHandler: completionHandler)
    }

    open func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        SignalBox.shared.moduleHandleEventsForBackgroundURLSession(identifier: identifier, completionHandler: completionHandler)
    }

    open func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
        SignalBox.shared.moduleHandleWatchKitExtensionRequest(userInfo: userInfo, reply: reply)
    }

    open func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        SignalBox.shared.moduleShouldRequestHealthAuthorization()
    }

    open func applicationDidEnterBackground(_ application: UIApplication) {
        SignalBox.shared.moduleDidEnterBackground()
    }

    open func applicationWillEnterForeground(_ application: UIApplication) {
        SignalBox.shared.moduleWillEnterForeground()
    }

    open func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        
        return SignalBox.shared.moduleShouldAllowExtensionPointIdentifier(extensionPointIdentifier: extensionPointIdentifier)
    }

    open func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        SignalBox.shared.continueUserActivity(activity: userActivity, restorationHandler: restorationHandler)
        return true
    }

    open func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        SignalBox.shared.didUpdateUserActivity(activity: userActivity)
    }

    open func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        SignalBox.shared.userDidAcceptCloudKitShareWith(cloudKitShareMetadata: cloudKitShareMetadata)
    }

}
