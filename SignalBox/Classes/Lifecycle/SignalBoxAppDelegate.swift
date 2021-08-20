//
//  SignalBoxAppDelegate.swift
//  SignalBox
//
//  Created by jimmy on 2021/8/20.
//

import Foundation
import CloudKit


///用于App级别的消息转发, 保证module拥有App完整地生命周期
public class SignalBoxAppDelegate: UIResponder, UIApplicationDelegate {
    
    public override func remoteControlReceived(with event: UIEvent?) {
        
    }
    
    @discardableResult public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return true
    }
    
    public func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        
    }
    
    
    public func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    public func applicationSignificantTimeChange(_ application: UIApplication) {
        
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
    }

    public func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        
    }

    public func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
        
    }

    public func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    public func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        
        return true
    }

    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        return true
    }

    public func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        
    }

    public func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        
    }

}
