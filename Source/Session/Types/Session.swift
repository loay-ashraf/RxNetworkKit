//
//  Session.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/11/2023.
//

import Foundation

/// Wrapper object for `URLSession` that can be shared between multiple clients.
public final class Session {
    
    /// Principal `URLSession`object used to create request tasks.
    let urlSession: URLSession
    
    /// Principal `TLSTrustEvaluator` object used to evaluate TLS server trust.
    private let tlsTrustEvaluator: TLSTrustEvaluator
    /// `OperationQueue` used by the TLS trust evaluator object.
    private let tlsTrustEvaluatorQueue: OperationQueue
    
    /// Creates a `Session` instance.
    ///
    /// - Parameters:
    ///   - configuration: `SessionConfiguration` object used to configure and create `URLSession` instance.
    public init(configuration: SessionConfiguration) {
        let urlSessionConfiguration = configuration.urlSessionConfiguration
        if configuration.setUserAgentHeader {
            // Apply User-Agent header as a part of HTTP aditional headers.
            urlSessionConfiguration.setUserAgentHTTPHeader()
        }
        URLSession.logRequests = configuration.logRequests
        tlsTrustEvaluator = .init(configuration: configuration.tlsTrustEvaluatorConfiguration)
        tlsTrustEvaluatorQueue = .init()
        tlsTrustEvaluatorQueue.name = "RxNetworkKit - TLSTrustEvaluator"
        tlsTrustEvaluatorQueue.qualityOfService = .utility
        // Initialize `URLSession`.
        urlSession = .init(configuration: urlSessionConfiguration,
                           delegate: tlsTrustEvaluator,
                           delegateQueue: tlsTrustEvaluatorQueue)
    }
    
}
