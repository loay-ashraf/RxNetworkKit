//
//  HTTPRequestRetrier.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 27/03/2023.
//

import Foundation

/// Retries requests upon failure.
public protocol HTTPRequestRetrier: AnyObject {
    
    /// Provides maximum retry attempts for a given request and session.
    ///
    /// - Parameters:
    ///   - request: current `URLRequest`
    ///   - session: current `URLSession`
    ///
    /// - Returns: `Int` maximum retry attempts for given request and session.
    func retryMaxAttempts(_ request: URLRequest, for session: URLSession) -> Int
    
    /// Provides retry policy for a given request and session.
    ///
    /// - Parameters:
    ///   - request: current `URLRequest`
    ///   - session: current `URLSession`
    ///
    /// - Returns: `NetworkRequestRetryPolicy` retry policy for given request and session.
    func retryPolicy(_ request: URLRequest, for session: URLSession) -> HTTPRequestRetryPolicy
    
    /// Decides if a given request should be reried for a given session and error.
    ///
    /// - Parameters:
    ///   - request: current `URLRequest`
    ///   - session: current `URLSession`
    ///   - error: encountered `NetworkError`
    ///
    /// - Returns: `NetworkRequestRetryPolicy` retry policy for given request and session.
    func shouldRetry(_ request: URLRequest, for session: URLSession, dueTo error: HTTPError) -> Bool
    
}
