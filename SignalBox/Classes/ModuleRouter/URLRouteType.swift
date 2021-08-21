//
//  URLRouteType.swift
//  SignalBox
//
//  Created by jimmy on 2021/8/23.
//

import Foundation

///生成ViewController的定义
public typealias ViewControllerFactory = (_ url: URLAnalysis, _ values: [String: Any], _ context: Any?) -> UIViewControllerType?

@objc public protocol UIViewControllerType {
    var viewController: UIViewController { get }
    ///当前的ViewController 是否支持push
    func shouldPush(from: UINavigationController) -> Bool
    ///当前的ViewController 是否支持present
    func shouldPresent(from: UIViewController) -> Bool
    ///present的 modalPresentationStyle
    func modalPresentationStyle(to: UIViewController) -> UIModalPresentationStyle
}

extension UIViewController: UIViewControllerType {
    
    @objc open var viewController: UIViewController {
        return self
    }
    
    @objc open func shouldPush(from: UINavigationController) -> Bool {
        return true
    }
    
    @objc open func shouldPresent(from: UIViewController) -> Bool {
        return true
    }
    
    ///默认全屏显示
    @objc open func modalPresentationStyle(to: UIViewController) -> UIModalPresentationStyle {
        return .fullScreen
    }
    
}


public enum URLOpenResult {
    case success(Any)
    case failed(Any)
    
    public static let voidSuccess = URLOpenResult.success(())
    public static let voidFailed = URLOpenResult.failed(())
}

///生成的方法定义
public typealias URLOpenHandleFactory = (_ url: URLAnalysis, _ values: [String: Any], _ context: Any?) -> URLOpenResult

