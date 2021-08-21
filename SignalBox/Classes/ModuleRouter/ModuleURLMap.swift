//
//  ModuleURLMap.swift
//  SignalBox
//
//  Created by jimmy on 2021/8/20.
//

import Foundation

///实现SignalBoxProviding的协议的类需要实现当前map协议
public protocol ModuleURLMap {
    //对应ViewController的路由
    var moduleURLRoutes: [String: ViewControllerFactory]? { get }
    //对应方法的路由
    var moduleURLHandles: [String: URLOpenHandleFactory]? { get }
}
