//
//  SignalBoxRequring.swift
//  SignalBox
//
//  Created by jimmy on 2021/8/20.
//

import Foundation

///定义module间通信的协议,需要对外暴露的通信方法的需要实现这个协议
public protocol SignalBoxRequiring {
    ///实现这个协议的 实现名
    var requiringProtocolname: String { get }
}

