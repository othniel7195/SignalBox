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

enum URLPathComponentMatchResult {
    case matches((key: String, value: Any)?)
    case notMatches
}

enum URLPathComponent {
    case plain(String)
    case placeholder(type: String?, key: String)
}

extension URLPathComponent {
    init(_ value: String) {
        if value.hasPrefix("<") && value.hasSuffix(">") {
            let start = value.index(after: value.startIndex)
            let end = value.index(before: value.endIndex)
            let placeholder = value[start..<end]
            let typeAndKey = placeholder.components(separatedBy: ":")
            if typeAndKey.count == 1 {
                self = .placeholder(type: nil, key: typeAndKey[0])
            } else if typeAndKey.count == 2 {
                self = .placeholder(type: typeAndKey[0], key: typeAndKey[1])
            } else {
                self = .plain(value)
            }
        } else {
            self = .plain(value)
        }
    }
}

extension URLPathComponent: Equatable {
    static func == (lhs: URLPathComponent, rhs: URLPathComponent) -> Bool {
        switch (lhs, rhs) {
        case let (.plain(leftValue), .plain(rightValue)):
            return leftValue == rightValue
            
        case let (.placeholder(leftType, leftKey), .placeholder(rightType, key: rightKey)):
            return (leftType == rightType) && (leftKey == rightKey)
            
        default:
            return false
        }
    }
}

///myapp://user/<int:id> 将会和下面的 URL 匹配
///myapp://user/123
///myapp://user/87
struct URLMatcher {
    
    typealias URLValueConverter = (_ pathComponents: [String], _ index: Int) -> Any?
    
    let defaultURLValueConverters: [String: URLValueConverter] = [
        "string": { pathComponents, index in
            return pathComponents[index]
        },
        "int": { pathComponents, index in
            return Int(pathComponents[index])
        },
        "uint64": { pathComponents, index in
            return UInt64(pathComponents[index])
        },
        "float": { pathComponents, index in
            return Float(pathComponents[index])
        },
        "path": { pathComponents, index in
            return pathComponents[index..<pathComponents.count].joined(separator: "/")
        }
    ]
    
    func match(_ url: URLAnalysis, from candidates: [URLPattern]) -> URLMatchResult? {
        let url = normalizeURL(url)
        let scheme = url.urlValue?.scheme
        let pathComponents = stringPathComponents(from: url)
        
        for candidate in candidates {
            guard scheme == candidate.urlValue?.scheme else { continue }
            if let result = match(pathComponents, with: candidate) {
                return result
            }
        }
        
        return nil
    }
    
}

extension URLMatcher {
    
    private func match(_ stringPathComponents: [String], with candidate: URLPattern) -> URLMatchResult? {
        let normalizedCandidate = self.normalizeURL(candidate).urlStringValue
        let candidatePathComponents = self.pathComponents(from: normalizedCandidate)
        guard self.ensurePathComponentsCount(stringPathComponents, candidatePathComponents) else {
            return nil
        }
        
        var urlValues: [String: Any] = [:]
        
        let pairCount = min(stringPathComponents.count, candidatePathComponents.count)
        for index in 0..<pairCount {
            let result = self.matchStringPathComponent(
                at: index,
                from: stringPathComponents,
                with: candidatePathComponents
            )
            
            switch result {
            case let .matches(placeholderValue):
                if let (key, value) = placeholderValue {
                    urlValues[key] = value
                }
                
            case .notMatches:
                return nil
            }
        }
        
        return URLMatchResult(pattern: candidate, values: urlValues)
    }
    
    private func ensurePathComponentsCount(
        _ stringPathComponents: [String],
        _ candidatePathComponents: [URLPathComponent]
    ) -> Bool {
        let hasSameNumberOfComponents = (stringPathComponents.count == candidatePathComponents.count)
        let containsPathPlaceholderComponent = candidatePathComponents.contains {
            if case let .placeholder(type, _) = $0, type == "path" {
                return true
            } else {
                return false
            }
        }
        return hasSameNumberOfComponents || containsPathPlaceholderComponent
    }
    
    private func pathComponents(from url: URLPattern) -> [URLPathComponent] {
        return stringPathComponents(from: url).map(URLPathComponent.init)
    }
    
    private func matchStringPathComponent(
        at index: Int,
        from stringPathComponents: [String],
        with candidatePathComponents: [URLPathComponent]
    ) -> URLPathComponentMatchResult {
        let stringPathComponent = stringPathComponents[index]
        let urlPathComponent = candidatePathComponents[index]
        
        switch urlPathComponent {
        case let .plain(value):
            guard stringPathComponent == value else { return .notMatches }
            return .matches(nil)
            
        case let .placeholder(type, key):
            guard let type = type, let converter = defaultURLValueConverters[type] else {
                return .matches((key, stringPathComponent))
            }
            if let value = converter(stringPathComponents, index) {
                return .matches((key, value))
            } else {
                return .notMatches
            }
        }
    }
    
    
    private func normalizeURL(_ dirtyURL: URLAnalysis) -> URLAnalysis {
        guard dirtyURL.urlValue != nil else { return dirtyURL }
        var urlString = dirtyURL.urlStringValue
        urlString = urlString.components(separatedBy: "?")[0].components(separatedBy: "#")[0]
        urlString = replaceRegex(":/{3,}", "://", urlString)
        urlString = replaceRegex("(?<!:)/{2,}", "/", urlString)
        urlString = replaceRegex("(?<!:|:/)/+$", "", urlString)
        return urlString
    }
    
    private func replaceRegex(_ pattern: String, _ repl: String, _ string: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return string }
        return regex.stringByReplacingMatches(in: string, options: [], range: NSMakeRange(0, string.count), withTemplate: repl)
    }
    
    private func stringPathComponents(from url: URLAnalysis) -> [String] {
        return url.urlStringValue.components(separatedBy: "/").lazy
            .filter { !$0.isEmpty }
            .filter { !$0.hasSuffix(":") }
    }
    
}
