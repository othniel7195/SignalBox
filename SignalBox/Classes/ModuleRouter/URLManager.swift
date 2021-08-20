//
//  URLManager.swift
//  SignalBox
//
//  Created by jimmy on 2021/8/20.
//

import Foundation


public typealias URLPattern = String

public protocol URLAnalysis {
    var urlValue: URL? { get }
    var urlStringValue: String { get }
    var queryItems: [URLQueryItem]? { get }
}

extension String: URLAnalysis {
    public var urlValue: URL? {
        var set = CharacterSet()
        set.formUnion(.urlHostAllowed)
        set.formUnion(.urlPathAllowed)
        set.formUnion(.urlQueryAllowed)
        set.formUnion(.urlFragmentAllowed)
        return addingPercentEncoding(withAllowedCharacters: set).flatMap { URL(string: $0) }
    }
    
    public var urlStringValue: String {
       return self
    }
    
    public var queryItems: [URLQueryItem]? {
        return URLComponents(string: self)?.queryItems
    }
    
}

extension URL: URLAnalysis {
    public var urlValue: URL? {
        return self
    }
    
    public var urlStringValue: String {
        return absoluteString
    }
    
    public var queryItems: [URLQueryItem]? {
        return URLComponents(string: urlStringValue)?.queryItems
    }
    
}

struct URLMatchResult {
    let pattern: URLPattern
    ///提取的url中占位符
    let values: [String: Any]
}


