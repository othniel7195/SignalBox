//
//  SignalBoxProviding.swift
//  SignalBox
//
//  Created by jimmy on 2021/8/20.
//

import Foundation
import CloudKit

///Module 的基本配置信息
public protocol ModuleSignalType {
    ///实现SignalBoxProviding协议的类的name
    var providerName: String { get }
    
    ///应当和对应的 Module Framework 名称一致
    var moduleName: String { get }
    
    var requringName: String { get }
}

extension ModuleSignalType {
    ///实现xxxProviding协议的编译后的name
    var providerFullName: String {
        return "\(moduleName).\(providerName)"
    }
}

///Module层的协议抽象
public protocol SignalBoxProviding {
    
    init(context: SignalBoxContext)
    
    // MARK: user state
    func userWillLogin()
    
    func userDidLogin()
    
    func userWillLogout()
    
    func userDidLogout()
    
    //  MARK: life cycle
    func remoteControlReceived(with event: UIEvent?)
    
    @discardableResult func moduleOpen(launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool
    
    func moduleDidBecomeActive()
    
    func moduleWillResignActive()
    
    @discardableResult func moduleOpenURL(url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
    
    func moduleDidReceiveMemoryWarning()
    
    func moduleWillTerminate()
    
    func moduleSignificantTimeChange()
    
    func moduleDidRegister(remoteNotificationsWithDeviceToken deviceToken: Data)
    
    func moduleDidFailToRegister(remoteNotificationsWithError error: Error)
    
    func moduleDidReceiveRemoteNotification(userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    
    func modulePerformAction(shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void)

    func moduleHandleEventsForBackgroundURLSession(identifier: String, completionHandler: @escaping () -> Void)

    func moduleHandleWatchKitExtensionRequest(userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void)

    func moduleShouldRequestHealthAuthorization()

    func moduleDidEnterBackground()

    func moduleWillEnterForeground()

    func moduleShouldAllowExtensionPointIdentifier(extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool

    @discardableResult func continueUserActivity(activity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool

    func didUpdateUserActivity(activity: NSUserActivity)

    func userDidAcceptCloudKitShareWith(cloudKitShareMetadata: CKShare.Metadata)
    
}


// MARK: 默认实现
extension SignalBoxProviding {
    
    public func userWillLogin() {}
    
    public func userDidLogin() {}
    
    public func userWillLogout() {}
    
    public func userDidLogout() {}
    
    public func remoteControlReceived(with event: UIEvent?) {}
    
    @discardableResult public func moduleOpen(launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        return true
    }
    
    public func moduleDidBecomeActive() {}
    
    public func moduleWillResignActive() {}
    
    public func moduleOpenURL(url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return true
    }
    
    public func moduleDidReceiveMemoryWarning(){}
    
    public func moduleWillTerminate() {}
    
    public func moduleSignificantTimeChange() {}
    
    public func moduleDidRegister(remoteNotificationsWithDeviceToken deviceToken: Data) {}
    
    public func moduleDidFailToRegister(remoteNotificationsWithError error: Error) {}
    
    public func moduleDidReceiveRemoteNotification(userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {}
    
    public func modulePerformAction(shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {}

    public func moduleHandleEventsForBackgroundURLSession(identifier: String, completionHandler: @escaping () -> Void) {}

    public func moduleHandleWatchKitExtensionRequest(userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {}

    public func moduleShouldRequestHealthAuthorization() {}

    public func moduleDidEnterBackground() {}

    public func moduleWillEnterForeground() {}

    public func moduleShouldAllowExtensionPointIdentifier(extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool { return true
    }

    public func continueUserActivity(activity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return true
    }

    public func didUpdateUserActivity(activity: NSUserActivity) {}

    public func userDidAcceptCloudKitShareWith(cloudKitShareMetadata: CKShare.Metadata) {}
}
