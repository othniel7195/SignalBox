//
//  SignalBox.swift
//  SignalBox
//
//  Created by jimmy on 2021/8/20.
//

import Foundation

struct SignalBoxLog {
    
    private let output: (String) -> Void
    
    init(_ output: @escaping (String) -> Void) {
        self.output = output
    }
    
    func log(_ message: String) {
        output("[SignalBox]: \(message)")
    }
    
    static var `default` = SignalBoxLog { message in
        #if DEBUG
        print(message)
        #endif
    }
}
