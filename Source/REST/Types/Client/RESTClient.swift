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
    
    /// Principal `Session` object that encapsulates `URLSession` instance.
    private let session: Session
    /// Principal `URLSession` object used to create request tasks.
    private var urlSession: URLSession {
        session.urlSession
    }
    /// Principal `HTTPRequestInterceptor` object used to intercept requests.
    private let requestInterceptor: HTTPRequestInterceptor
    /// Principal `HTTPRequestEventMonitor` object used to monitor request tasks.
    private var eventMonitor: HTTPRequestEventMonitor {
        session.eventMonitor
    }
    
    /// Creates a `RESTClient` instance.
    ///
    /// - Parameters:
    ///   - session: `Session` object that encapsulates `URLSession` instance.
    ///   - requestInterceptor: `HTTPRequestInterceptor` object used for intercepting requests.
    public init(session: Session, requestInterceptor: HTTPRequestInterceptor) {
        // Initialize manager's properties.
        self.session = session
        self.requestInterceptor = requestInterceptor
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
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: urlSession)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: urlSession)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: urlSession)
        let shouldRetry = { (error: HTTPError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.urlSession, dueTo: error)
        }
        let observable = urlSession
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
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: urlSession)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: urlSession)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: urlSession)
        let shouldRetry = { (error: HTTPError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.urlSession, dueTo: error)
        }
        let observable = urlSession
            .rx
            .response(request: adaptedRequest)
            .decodable(T.self, httpErrorType: E.self, apiErrorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
    
}
