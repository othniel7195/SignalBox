//
//  ModuleURLMap.swift
//  SignalBox
//
//  Created by jimmy on 2021/8/20.
//

import Foundation

public protocol ModuleURLMap {
    //对应ViewController的路由
    var moduleURLRoutes: [String: ViewControllerFactory]? { get }
    //对应方法的路由
    var moduleURLHandles: [String: URLOpenHandleFactory]? { get }
}
