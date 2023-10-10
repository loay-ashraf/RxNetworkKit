//
//  HTTPClient.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 10/10/2023.
//

import Foundation
import RxSwift

/// Entry point for creating http requests.
public class HTTPClient {
    
    /// Principal `URLSession` used to create request tasks.
    private let session: URLSession
    /// Principal `HTTPRequestInterceptor` used to intercept requests.
    private let requestInterceptor: HTTPRequestInterceptor
    /// Principal `HTTPRequestEventMonitor` used to monitor request tasks.
    private let eventMonitor: HTTPRequestEventMonitor
    
    /// Creates a `HTTPClient` instance.
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
    
    /// Creates a `Observable` object encapsulating download request using given `Router`.
    /// Use this method if you are downloading a relatively small file (keeps data in memory).
    ///
    /// - Parameters:
    ///   - router: `HTTPDownloadRequestRouter` object used to create request.
    ///   - httpErrorType: `HTTPBodyError` http body error type.
    ///   - apiErrorType: `HTTPAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating download request.
    public func download<E: HTTPBodyError, AE: HTTPAPIError>(_ router: HTTPDownloadRequestRouter, _ httpErrorType: E.Type = DefaultHTTPBodyError.self, _ apiErrorType: AE.Type = DefaultHTTPAPIError.self) -> Observable<HTTPDownloadRequestEvent> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: HTTPError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.session, dueTo: error)
        }
        let observable = session
            .rx
            .downloadResponse(request: adaptedRequest, httpErrorType: E.self, apiErrorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
    
    /// Creates a `Observable` object encapsulating download request using given `Router`.
    /// Use this method if you are downloading a relatively small file (saves file to disk).
    ///
    /// - Parameters:
    ///   - router: `HTTPDownloadRequestRouter` object used to create request.
    ///   - fileURL: `URL` used to save downloaded file to disk.
    ///   - httpErrorType: `HTTPBodyError` http body error type.
    ///   - apiErrorType: `HTTPAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating download request.
    public func download<E: HTTPBodyError, AE: HTTPAPIError>(_ router: HTTPDownloadRequestRouter, _ fileURL: URL, _ httpErrorType: E.Type = DefaultHTTPBodyError.self, _ apiErrorType: AE.Type = DefaultHTTPAPIError.self) -> Observable<HTTPDownloadRequestEvent> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: HTTPError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.session, dueTo: error)
        }
        let observable = session
            .rx
            .downloadResponse(request: adaptedRequest, saveTo: fileURL, httpErrorType: E.self, apiErrorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
    
    /// Creates a `Observable` object encapsulating upload request using given `Router`.
    /// Use this method if you are uploading single file at a time.
    ///
    /// - Parameters:
    ///   - router: `HTTPUploadRequestRouter` object used to create request.
    ///   - file: `HTTPUploadRequestFile` object including file details for upload.
    ///   - httpErrorType: `HTTPBodyError` http body error type.
    ///   - apiErrorType: `HTTPAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating upload request.
    public func upload<T: Decodable, E: HTTPBodyError, AE: HTTPAPIError>(_ router: HTTPUploadRequestRouter, _ file: HTTPUploadRequestFile, _ httpErrorType: E.Type = DefaultHTTPBodyError.self, _ apiErrorType: AE.Type = DefaultHTTPAPIError.self) -> Observable<HTTPUploadRequestEvent<T>> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: HTTPError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.session, dueTo: error)
        }
        let observable = session
            .rx
            .uploadResponse(request: adaptedRequest, file: file, modelType: T.self, httpErrorType: E.self, apiErrorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
    
    /// Creates a `Observable` object encapsulating upload request using given `Router`.
    /// Use this method if you are uploading multiple files at a time.
    ///
    /// - Parameters:
    ///   - router: `HTTPUploadRequestRouter` object used to create request.
    ///   - formData: `HTTPUploadRequestFormData` object including parameters and files for upload.
    ///   - httpErrorType: `HTTPBodyError` http body error type.
    ///   - apiErrorType: `HTTPAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating upload request.
    public func upload<T: Decodable, E: HTTPBodyError, AE: HTTPAPIError>(_ router: HTTPUploadRequestRouter, _ formData: HTTPUploadRequestFormData, _ httpErrorType: E.Type = DefaultHTTPBodyError.self, _ apiErrorType: AE.Type = DefaultHTTPAPIError.self) -> Observable<HTTPUploadRequestEvent<T>> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: HTTPError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.session, dueTo: error)
        }
        let observable = session
            .rx
            .uploadResponse(request: adaptedRequest, formData: formData, modelType: T.self, httpErrorType: E.self, apiErrorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
    
    /// Creates websocket object and establishes connection using provided url and protocols.
    ///
    /// - Parameters:
    ///   - url: `URL` of websocket server.
    ///   - protocols: `[String]` websocket connection protocols.
    ///   - closeHandler: `WebSocketCloseHandler` used to provide close coda and reason upon connection closure.
    ///
    /// - Returns: `WebSocket` object that represents the connection.
    public func webSocket<T: Decodable>(_ url: URL, _ protocols: [String], _ closeHandler: WebSocketCloseHandler) -> WebSocket<T> {
        let task = session.webSocketTask(with: url, protocols: protocols)
        let webSocket = WebSocket<T>(task: task, closeHandler: closeHandler)
        return webSocket
    }
    
}
