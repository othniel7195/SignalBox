//
//  ModuleRouter.swift
//  SignalBox
//
//  Created by jimmy on 2021/8/24.
//

import Foundation

public class ModuleRouter {
    
    private let tag = "SignalBox Router"
    
    private let matcher = URLMatcher()
    
    private var viewControllerFactories = [String: ViewControllerFactory]()
    
    private var handlerFactories = [String: URLOpenHandleFactory]()
    
    ///注册一个对应 pattern 的 ViewController 的实现。
    public func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory) {
        SignalBoxLog.default.log("\(tag) reregister ViewController Pattern: \(pattern), ViewControllerFactory is \(String(describing: factory))")
        viewControllerFactories[pattern] = factory
    }
    
    ///注册一个对应 pattern 的 方法 的实现。
    public func handle(_ pattern: URLPattern, _ factory: @escaping URLOpenHandleFactory) {
        SignalBoxLog.default.log("\(tag) register Function Pattern: \(pattern), URLOpenHandleFactory is \(String(describing: factory))")
        handlerFactories[pattern] = factory
    }
    
    public func viewController(url: URLAnalysis, context: Any? = nil) -> UIViewControllerType? {
        let urlPatterns = viewControllerFactories.keys.map { $0 }
        guard let match = matcher.match(url, from: urlPatterns) else {
            SignalBoxLog.default.log("\(tag) get ViewController with url: \(url), context: \(String(describing: context)), pattern not match.")
            return nil
        }
        guard let factory = viewControllerFactories[match.pattern] else {
            SignalBoxLog.default.log("Rainbow Router get ViewController with url: \(url), context: \(String(describing: context)), ViewControllerFactory not found.")
            return nil
        }
        let viewControllerType = factory(url, match.values, context)
        SignalBoxLog.default.log("\(tag) get ViewController with url: \(url), context: \(String(describing: context)), ViewController is \(String(describing: viewControllerType))")
        return viewControllerType
    }
    
    public func handler(url: URLAnalysis, context: Any? = nil) -> URLOpenResult {
        let urlPatterns = handlerFactories.keys.map { $0 }
        guard let match = matcher.match(url, from: urlPatterns) else {
            SignalBoxLog.default.log("\(tag) get Function with url: \(url), context: \(String(describing: context)), pattern not match.")
            return .voidFailed
        }
        guard let handler = handlerFactories[match.pattern] else {
            SignalBoxLog.default.log("\(tag) get Function with url: \(url), context: \(String(describing: context)), URLOpenHandleFactory not found.")
            return .voidFailed
        }
        
        return handler(url, match.values, context)
    }
    
    @discardableResult public func push(_ url: URLAnalysis,
                                        context: Any? = nil,
                                        from: UINavigationController? = nil,
                                        animated: Bool = true) -> UIViewController? {
        guard let viewControllerType = viewController(url: url, context: context) else {
            SignalBoxLog.default.log("\(tag) try to push ViewController with url: \(url), context: \(String(describing: context)), get ViewController failed.")
            return nil
        }
        let viewController = push(viewControllerType, from: from, animated: animated)
        SignalBoxLog.default.log("\(tag) try to push ViewController with url: \(url), context: \(String(describing: context)), viewController is \(String(describing: viewController)).")
        return viewController
    }
    
    @discardableResult public func push(_ viewControllerType: UIViewControllerType,
                                        from: UINavigationController? = nil,
                                        animated: Bool = true) -> UIViewController? {
        guard (viewControllerType.viewController is UINavigationController) == false else {
            return nil
        }
        guard let navigationController = from ?? UIViewController.topMost?.navigationController else {
            return nil
        }
        if navigationController.signalBox_isVisible {
            navigationController.pushViewController(viewControllerType.viewController, animated: animated)
        } else {
            navigationController.signalBox_didAppear = { [weak navigationController] in
                DispatchQueue.main.async {
                    navigationController?.pushViewController(viewControllerType.viewController, animated: animated)
                }
                navigationController?.signalBox_didAppear = nil
            }
        }
        
        return viewControllerType.viewController
    }
    
    ///对present的ViewController进行UINavigationController包装
    @discardableResult public func present(_ url: URLAnalysis,
                                           context: Any? = nil,
                                           wrap: UINavigationController.Type? = UINavigationController.self,
                                           from: UIViewController? = nil,
                                           animated: Bool = true,
                                           completion: (() -> Void)? = nil) -> UIViewController? {
        guard let viewControllerType = viewController(url: url, context: context) else {
            SignalBoxLog.default.log("\(tag) try to present ViewController with url: \(url), context: \(String(describing: context)), get ViewController failed.")
            return nil
        }
        let viewController = present(viewControllerType, wrap: wrap, from: from, animated: animated, completion: completion)
        SignalBoxLog.default.log("\(tag) try to present ViewController with url: \(url), context: \(String(describing: context)), viewController is \(String(describing: viewController)).")
        return viewController
    }
    
    @discardableResult public func present(_ viewControllerType: UIViewControllerType,
                                           wrap: UINavigationController.Type? = UINavigationController.self,
                                           from: UIViewController? = nil,
                                           animated: Bool = true,
                                           completion: (() -> Void)? = nil) -> UIViewController? {
        guard let fromViewController = from ?? UIViewController.topMost else {
            return nil
        }
        let viewControllerToPresent: UIViewController
        if let navigationControllerClass = wrap, (viewControllerType.viewController is UINavigationController) == false {
            viewControllerToPresent = navigationControllerClass.init(rootViewController: viewControllerType.viewController)
        } else {
            viewControllerToPresent = viewControllerType.viewController
        }
        guard viewControllerType.shouldPresent(from: fromViewController) else {
            return nil
        }
        viewControllerToPresent.modalPresentationStyle = viewControllerType.modalPresentationStyle(to: viewControllerToPresent)
        if fromViewController.signalBox_isVisible {
            fromViewController.present(viewControllerToPresent, animated: animated, completion: completion)
        } else {
            fromViewController.signalBox_didAppear = { [weak fromViewController] in
                DispatchQueue.main.async {
                    fromViewController?.present(viewControllerToPresent, animated: animated, completion: completion)
                }
                fromViewController?.signalBox_didAppear = nil
            }
        }
        return viewControllerType.viewController
    }
    
    @discardableResult open func open(_ url: URLAnalysis,
                                      context: Any? = nil,
                                      wrap: UINavigationController.Type? = UINavigationController.self,
                                      from: UIViewController? = nil,
                                      animated: Bool = true) -> UIViewController? {
        
        guard let viewControllerType = viewController(url: url, context: context) else {
            SignalBoxLog.default.log("\(tag) try to open ViewController with url: \(url), context: \(String(describing: context)), get ViewController failed.")
            return nil
        }
        if let viewController = push(viewControllerType, from: from as? UINavigationController, animated: animated) {
            SignalBoxLog.default.log("\(tag) open ViewController with url: \(url), context: \(String(describing: context)), and used Push, viewController is \(viewController)")
            return viewController
        } else {
            let viewController = present(viewControllerType, wrap: wrap, from: from, animated: animated, completion: nil)
            SignalBoxLog.default.log("\(tag) open ViewController with url: \(url), context: \(String(describing: context)), and used Present, viewController is \(String(describing: viewController))")
            return viewController
        }
    }
    
    @discardableResult public func resolve(_ url: URLAnalysis, context: Any? = nil, wrap: UINavigationController.Type? = UINavigationController.self, from: UIViewController? = nil, animated: Bool = true) -> URLOpenResult {
        let result = handler(url: url, context: context)
        switch result {
        case .failed:
            let viewController = open(url, context: context, wrap: wrap, from: from, animated: animated)
            return viewController.map { return URLOpenResult.success($0) } ?? result
        case .success:
            return result
        }
    }
    
}
