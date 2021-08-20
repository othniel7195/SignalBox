//
//  URLTests.swift
//  SignalBox_Tests
//
//  Created by jimmy on 2021/8/20.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest

class URLTests: XCTestCase {
    override class func setUp() {
        super.setUp()
    }
    override class func tearDown() {
        super.tearDown()
    }
    
    func testURLAnalysis() {
        let string = "https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&rsv_idx=1&tn=baidu&wd=iOS&fenlei=256&rsv_pq=eb48bedb00049a73&rsv_t=acb77ASAekk%2BUxNbzrVCye8EVnEb86hrs4Fa%2BCURqktB8ZORY9fhRTdgJjw&rqlang=cn&rsv_dl=tb&rsv_sug3=4&rsv_sug1=3&rsv_sug7=101&rsv_enter=1&rsv_sug2=0&rsv_btype=i&prefixsug=iOS&rsp=5&inputT=892&rsv_sug4=2629"
        
        let url = URL(string: "https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&rsv_idx=1&tn=baidu&wd=iOS&fenlei=256&rsv_pq=eb48bedb00049a73&rsv_t=acb77ASAekk%2BUxNbzrVCye8EVnEb86hrs4Fa%2BCURqktB8ZORY9fhRTdgJjw&rqlang=cn&rsv_dl=tb&rsv_sug3=4&rsv_sug1=3&rsv_sug7=101&rsv_enter=1&rsv_sug2=0&rsv_btype=i&prefixsug=iOS&rsp=5&inputT=892&rsv_sug4=2629")!
        
        XCTAssertNotNil(string.urlValue, "URL to String Value Failed: \(String(describing: string.urlValue))")
        
        XCTAssertEqual(url.queryItems, string.queryItems)
    }

    
}
