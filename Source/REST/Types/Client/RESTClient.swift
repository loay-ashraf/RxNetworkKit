//
//  RESTClient.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 10/10/2023.
//

import Foundation
import RxSwift

/// Entry point for creating rest requests.
public class RESTClient {
    
    /// Principal `URLSession` used to create request tasks.
    private let session: URLSession
    /// Principal `HTTPRequestInterceptor` used to intercept requests.
    private let requestInterceptor: HTTPRequestInterceptor
    /// Principal `HTTPRequestEventMonitor` used to monitor request tasks.
    private let eventMonitor: HTTPRequestEventMonitor
    
    /// Creates a `RESTClient` instance.
    ///
    /// - Parameters:
    ///   - configuration: `URLSessionConfiguration` object used to create `URLSession` instance.
    ///   - requestInterceptor: `HTTPRequestInterceptor` object used for intercepting requests.
    ///   - eventMonitor: `HTTPRequestEventMonitor` object for monitoring events for session.
    public init(configuration: URLSessionConfiguration, requestInterceptor: HTTPRequestInterceptor, eventMonitor: HTTPRequestEventMonitor) {
        // Apply User-Agent header as a part of HTTP aditional headers.
        configuration.setUserAgentHTTPHeader()
        // Initialize manager's properties.
        URLSession.rx.shouldLogRequest = { _ in false }
        self.session = .init(configuration: configuration, delegate: eventMonitor, delegateQueue: nil)
        self.requestInterceptor = requestInterceptor
        self.eventMonitor = eventMonitor
    }
    
    /// Creates a `Completable` observable encapsulating data request using given `Router`.
    /// Use this method if you are expecting empty response body.
    ///
    /// - Parameters:
    ///   - router: `Router` object used to create request.
    ///   - httpErrorType: `HTTPBodyError` http body error type.
    ///   - apiErrorType: `HTTPAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Completable` observable encapsulating data request.
    public func request<E: HTTPBodyError, AE: HTTPAPIError>(_ router: HTTPRequestRouter, _ httpErrorType: E.Type = DefaultHTTPBodyError.self, _ apiErrorType: AE.Type = DefaultHTTPAPIError.self) -> Completable {
        
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: HTTPError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.session, dueTo: error)
        }
        let observable = session
            .rx
            .response(request: adaptedRequest)
            .decodable(E.self, apiErrorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
    
    /// Creates a `Single` observable encapsulating data request using given `Router`.
    /// Use this method if you are expecting data in response body.
    ///
    /// - Parameters:
    ///   - router: `Router` object used to create request.
    ///   - httpErrorType: `HTTPBodyError` http body error type.
    ///   - apiErrorType: `HTTPAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Single` observable encapsulating data request.
    public func request<T: Decodable, E: HTTPBodyError, AE: HTTPAPIError>(_ router: HTTPRequestRouter, _ httpErrorType: E.Type = DefaultHTTPBodyError.self, _ apiErrorType: AE.Type = DefaultHTTPAPIError.self) -> Single<T> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: HTTPError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.session, dueTo: error)
        }
        let observable = session
            .rx
            .response(request: adaptedRequest)
            .decodable(T.self, httpErrorType: E.self, apiErrorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
    
}
