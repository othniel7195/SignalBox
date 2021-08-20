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
    ///实现SignalBoxProviding 协议的名称
    var providingProtocolname: String { get }
    
    ///应当和对应的 Module Framework 名称一致
    var moduleName: String { get }
}

extension ModuleSignalType {
    var fullName: String {
        return "\(moduleName).\(providingProtocolname)"
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
    
    func moduleOpenURL(url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
    
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

    func continueUserActivity(activity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool

    func didUpdateUserActivity(activity: NSUserActivity)

    func userDidAcceptCloudKitShareWith(cloudKitShareMetadata: CKShare.Metadata)
    
}


// MARK: 默认实现
extension SignalBoxProviding {
    
    func userWillLogin() {}
    
    func userDidLogin() {}
    
    func userWillLogout() {}
    
    func userDidLogout() {}
    
    func remoteControlReceived(with event: UIEvent?) {}
    
    @discardableResult func moduleOpen(launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        return true
    }
    
    func moduleDidBecomeActive() {}
    
    func moduleWillResignActive() {}
    
    func moduleOpenURL(url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return true
    }
    
    func moduleDidReceiveMemoryWarning(){}
    
    func moduleWillTerminate() {}
    
    func moduleSignificantTimeChange() {}
    
    func moduleDidRegister(remoteNotificationsWithDeviceToken deviceToken: Data) {}
    
    func moduleDidFailToRegister(remoteNotificationsWithError error: Error) {}
    
    func moduleDidReceiveRemoteNotification(userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {}
    
    func modulePerformAction(shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {}

    func moduleHandleEventsForBackgroundURLSession(identifier: String, completionHandler: @escaping () -> Void) {}

    func moduleHandleWatchKitExtensionRequest(userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {}

    func moduleShouldRequestHealthAuthorization() {}

    func moduleDidEnterBackground() {}

    func moduleWillEnterForeground() {}

    func moduleShouldAllowExtensionPointIdentifier(extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool { return true
    }

    func continueUserActivity(activity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return true
    }

    func didUpdateUserActivity(activity: NSUserActivity) {}

    func userDidAcceptCloudKitShareWith(cloudKitShareMetadata: CKShare.Metadata) {}
}
