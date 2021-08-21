//
//  UIViewController+TopMost.swift
//  SignalBox
//
//  Created by jimmy on 2021/8/23.
//

import Foundation

extension UIViewController {
    
    open class var topMost: UIViewController? {
        let currentWindows = UIApplication.shared.windows
        var rootViewController: UIViewController?
        for window in currentWindows {
            if let windowRootViewController = window.rootViewController {
                rootViewController = windowRootViewController
                break
            }
        }
        let viewController = topMost(of: rootViewController)
        SignalBoxLog.default.log("get topMost viewController: \(String(describing: viewController))")
        return viewController
    }
    
    open class func topMost(of viewController: UIViewController?) -> UIViewController? {
        if let presentedViewController = viewController?.presentedViewController {
            return topMost(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return topMost(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return topMost(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
           pageViewController.viewControllers?.count == 1 {
            return topMost(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return topMost(of: childViewController)
            }
        }
        
        return viewController
    }
}
