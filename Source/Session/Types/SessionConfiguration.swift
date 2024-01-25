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
        .init(urlSessionConfiguration: .default, setUserAgentHeader: true, logRequests: true)
    }
    
    /// `URLSessionConfiguration` object used to create `URLSession` object.
    let urlSessionConfiguration: URLSessionConfiguration
    /// `Bool` flag that indicates wether a `URLSession` should add `User-Agent` header to outgoing requests.
    let setUserAgentHeader: Bool
    /// `Bool` flag that indicates wether a `URLSession` should print outgoing requests to the console.
    let logRequests: Bool
    
    /// Creates a `SessionConfiguration` instance.
    ///
    /// - Parameters:
    ///   - urlSessionConfiguration: `URLSessionConfiguration` object used to create `URLSession` object.
    ///   - setUserAgentHeader: `Bool` flag that indicates wether a `URLSession` should add `User-Agent` header to outgoing requests.
    ///   - logRequests: `Bool` flag that indicates wether a `URLSession` should print outgoing requests to the console.
    public init(urlSessionConfiguration: URLSessionConfiguration, setUserAgentHeader: Bool, logRequests: Bool) {
        self.urlSessionConfiguration = urlSessionConfiguration
        self.setUserAgentHeader = setUserAgentHeader
        self.logRequests = logRequests
    }
    
}
