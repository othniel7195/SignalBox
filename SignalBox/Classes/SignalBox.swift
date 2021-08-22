//
//  SignalBox.swift
//  SignalBox
//
//  Created by jimmy on 2021/8/24.
//

import Foundation
import CloudKit

public class SignalBox {
    
    private let tag = "SignalBox"
    
    public static let shared = SignalBox()
    
    public let router = ModuleRouter()
    
    public var context = SignalBoxContext() {
        didSet {
            SignalBoxLog.default.log("\(tag) set context: \(context)")
        }
    }
    
    /// 注册 Module 模块
    public func register(module: ModuleSignalType) {
        SignalBoxLog.default.log("\(tag) registger module: \(module.moduleName)")
        let provider = buildProviding(providerName: module.providerFullName)
        moduleCache[module.providerName] = provider
        if let requiring = provider as? SignalBoxRequiring {
            requiringCache[module.requringName] = requiring
        }
        provider.map { handleProviderRoutable(provider: $0) }
    }
    
    ///获取对应的requiring实现
    public func requiring<T>() -> T? {
        return requiringCache["\(T.self)"] as? T
    }
    
    private init() {}
    private var moduleCache = [String: SignalBoxProviding]()
    private var requiringCache = [String: SignalBoxRequiring]()
    
    private func buildProviding(providerName: String) -> SignalBoxProviding? {
        if let Klass = NSClassFromString(providerName) as? SignalBoxProviding.Type {
            let provider = Klass.init(context: context)
            return provider
        } else {
            return nil
        }
    }
    
    private func handleProviderRoutable(provider: Any) {
        if let provider = provider as? ModuleURLMap {
            if let urlRoutes = provider.moduleURLRoutes {
                for (k, v) in urlRoutes {
                    router.register(k, v)
                }
            }
            if let urlHandlers = provider.moduleURLHandles {
                for (k, v) in urlHandlers {
                    router.handle(k, v)
                }
            }
        }
    }
    
}


extension SignalBox {
    public func userWillLogin() {
        moduleCache.forEach { (_, provider) in
            provider.userWillLogin()
        }
    }
    
    public func userDidLogin() {
        moduleCache.forEach { (_, provider) in
            provider.userDidLogin()
        }
    }
    
    public func userWillLogout() {
        moduleCache.forEach { (_, provider) in
            provider.userWillLogout()
        }
    }
    
    public func userDidLogout() {
        moduleCache.forEach { (_, provider) in
            provider.userDidLogout()
        }
    }
    
    func remoteControlReceived(with event: UIEvent?) {
        moduleCache.forEach { (_, provider) in
            provider.remoteControlReceived(with: event)
        }
    }
    
    @discardableResult func moduleOpen(launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        moduleCache.forEach { (_, provider) in
            provider.moduleOpen(launchOptions: launchOptions)
        }
        return true
    }
    
    func moduleDidBecomeActive() {
        moduleCache.forEach { (_, provider) in
            provider.moduleDidBecomeActive()
        }
    }
    
    func moduleWillResignActive() {
        moduleCache.forEach { (_, provider) in
            provider.moduleWillResignActive()
        }
    }
    
    @discardableResult func moduleOpenURL(url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        moduleCache.forEach { (_, provider) in
            provider.moduleOpenURL(url: url, options: options)
        }
        return true
    }
    
    func moduleDidReceiveMemoryWarning(){
        moduleCache.forEach { (_, provider) in
            provider.moduleDidReceiveMemoryWarning()
        }
    }
    
    func moduleWillTerminate() {
        moduleCache.forEach { (_, provider) in
            provider.moduleWillTerminate()
        }
    }
    
    func moduleSignificantTimeChange() {
        moduleCache.forEach { (_, provider) in
            provider.moduleSignificantTimeChange()
        }
    }
    
    func moduleDidRegister(remoteNotificationsWithDeviceToken deviceToken: Data) {
        moduleCache.forEach { (_, provider) in
            provider.moduleDidRegister(remoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    func moduleDidFailToRegister(remoteNotificationsWithError error: Error) {
        moduleCache.forEach { (_, provider) in
            provider.moduleDidFailToRegister(remoteNotificationsWithError: error)
        }
    }
    
    func moduleDidReceiveRemoteNotification(userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        moduleCache.forEach { (_, provider) in
            provider.moduleDidReceiveRemoteNotification(userInfo: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
    
    func modulePerformAction(shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        moduleCache.forEach { (_, provider) in
            provider.modulePerformAction(shortcutItem: shortcutItem, completionHandler: completionHandler)
        }
    }
    
    func moduleHandleEventsForBackgroundURLSession(identifier: String, completionHandler: @escaping () -> Void) {
        moduleCache.forEach { (_, provider) in
            provider.moduleHandleEventsForBackgroundURLSession(identifier: identifier, completionHandler: completionHandler)
        }
    }
    
    func moduleHandleWatchKitExtensionRequest(userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
        moduleCache.forEach { (_, provider) in
            provider.moduleHandleWatchKitExtensionRequest(userInfo: userInfo, reply: reply)
        }
    }
    
    func moduleShouldRequestHealthAuthorization() {
        moduleCache.forEach { (_, provider) in
            provider.moduleShouldRequestHealthAuthorization()
        }
    }
    
    func moduleDidEnterBackground() {
        moduleCache.forEach { (_, provider) in
            provider.moduleDidEnterBackground()
        }
    }
    
    func moduleWillEnterForeground() {
        moduleCache.forEach { (_, provider) in
            provider.moduleWillEnterForeground()
        }
    }
    
    func moduleShouldAllowExtensionPointIdentifier(extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        var shouldAllow = true
        moduleCache.forEach { (_, provider) in
            if !provider.moduleShouldAllowExtensionPointIdentifier(extensionPointIdentifier: extensionPointIdentifier) {
                shouldAllow = false
            }
        }
        return shouldAllow
    }
    
    @discardableResult func continueUserActivity(activity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        moduleCache.forEach { (_, provider) in
            provider.continueUserActivity(activity: activity, restorationHandler: restorationHandler)
        }
        return true
    }
    
    func didUpdateUserActivity(activity: NSUserActivity) {
        moduleCache.forEach { (_, provider) in
            provider.didUpdateUserActivity(activity: activity)
        }
    }
    
    func userDidAcceptCloudKitShareWith(cloudKitShareMetadata: CKShare.Metadata) {
        moduleCache.forEach { (_, provider) in
            provider.userDidAcceptCloudKitShareWith(cloudKitShareMetadata: cloudKitShareMetadata)
        }
    }
}
