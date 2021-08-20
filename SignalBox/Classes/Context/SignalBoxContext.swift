//
//  SignalBoxContext.swift
//  SignalBox
//
//  Created by jimmy on 2021/8/20.
//

import Foundation

public struct SignalBoxContext {
    
    ///预留自定义数据
    public var customContext: Any?
    
    ///feature 开发环境
    ///test 测试环境
    ///pre_prod 模拟生产环境
    ///prod 生产环境
    public enum Environment {
        case feature
        case test
        case pre_prod
        case prod
      }
      
    /// 当前项目的初始环境信息
    public let environment: Environment
    
    ///router地scheme
    public let scheme: String
    
    init(_ scheme: String = "SignalBox", environment: Environment = .prod, customContext: Any? = nil) {
        self.scheme = scheme
        self.environment = environment
        self.customContext = customContext
    }
}
