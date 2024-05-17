//
//  SessionConfiguration.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/01/2024.
//

import Foundation

/// Wrapper object for `URLSessionConfiguration` and additional configuration parameters.
public class SessionConfiguration {
    
    /// Default `SessionConfiguration` object.
    public static var `default`: SessionConfiguration {
        .init(urlSessionConfiguration: .default)
    }
    /// Ephemeral `SessionConfiguration` object.
    public static var ephemeral: SessionConfiguration {
        .init(urlSessionConfiguration: .ephemeral)
    }
    
    /// `URLSessionConfiguration` object used to create `URLSession` object.
    let urlSessionConfiguration: URLSessionConfiguration
    /// `TLSTrustEvaluatorConfiguration` object used to create `TLSTrustEvaluator` object.
    public var tlsTrustEvaluatorConfiguration: TLSTrustEvaluatorConfiguration = .default
    /// `Bool` flag that indicates wether a `URLSession` should add `User-Agent` header to outgoing requests.
    public var setUserAgentHeader: Bool = true
    /// `Bool` flag that indicates wether a `URLSession` should print outgoing requests to the console.
    public var logRequests: Bool = true
    
    /// Creates a `SessionConfiguration` instance.
    ///
    /// - Parameters:
    ///   - urlSessionConfiguration: `URLSessionConfiguration` object used to create `URLSession` object.
    public init(urlSessionConfiguration: URLSessionConfiguration) {
        self.urlSessionConfiguration = urlSessionConfiguration
    }
    
    
    /// Creates a background `SessionConfiguration` object using the given identifier.
    ///
    /// - Parameter identifier: `String` background session identifier.
    ///
    /// - Returns: `SessionConfiguration` background  session configuration.
    public static func background(withIdentifier identifier: String) -> SessionConfiguration {
        .init(urlSessionConfiguration: .background(withIdentifier: identifier))
    }
    
}
