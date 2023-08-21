//
//  NetworkManager.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 16/02/2023.
//

import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa

public class NetworkManager {
    private let session: URLSession
    private let requestInterceptor: NetworkRequestInterceptor
    private let eventMonitor: NetworkEventMonitor
    /// Creates `NetworkManager` instance.
    ///
    /// - Parameters:
    ///   - configuration: `URLSessionConfiguration` object used to create `URLSession` instance.
    ///   - requestInterceptor: `NetworkRequestInterceptor` object used for intercepting requests.
    ///   - eventMonitor: `NetworkEventMonitor` object for monitoring events for session.
    public init(configuration: URLSessionConfiguration, requestInterceptor: NetworkRequestInterceptor, eventMonitor: NetworkEventMonitor) {
        // Apply User-Agent header as a part of HTTP aditional headers.
        configuration.setUserAgentHTTPHeader()
        // Initialize manager's properties.
        self.session = .init(configuration: configuration, delegate: eventMonitor, delegateQueue: nil)
        self.requestInterceptor = requestInterceptor
        self.eventMonitor = eventMonitor
    }
    /// Creates a `Completable` observable encapsulating data request using given `Router`.
    /// Use this method if you are expecting empty response body.
    ///
    /// - Parameters:
    ///   - router: `Router` object used to create request.
    ///   - httpErrorType: `HTTPErrorBody` http error body type.
    ///   - apiErrorType: `NetworkAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Completable` observable encapsulating data request.
    public func request<E: HTTPErrorBody, AE: NetworkAPIError>(_ router: NetworkRouter, _ httpErrorType: E.Type = DefaultHTTPErrorBody.self, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Completable {
        
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: NetworkError) in
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
    ///   - httpErrorType: `HTTPErrorBody` http error body type.
    ///   - apiErrorType: `NetworkAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Single` observable encapsulating data request.
    public func request<T: Decodable, E: HTTPErrorBody, AE: NetworkAPIError>(_ router: NetworkRouter, _ httpErrorType: E.Type = DefaultHTTPErrorBody.self, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Single<T> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: NetworkError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.session, dueTo: error)
        }
        let observable = session
            .rx
            .response(request: adaptedRequest)
            .decodable(T.self, httpErrorType: E.self, apiErrorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
    /// Creates a `Observable` object encapsulating download request using given `Router`.
    /// Use this method if you are downloading a relatively small file (keeps data in memory).
    ///
    /// - Parameters:
    ///   - router: `Router` object used to create request.
    ///   - httpErrorType: `HTTPErrorBody` http error body type.
    ///   - apiErrorType: `NetworkAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating download request.
    public func download<E: HTTPErrorBody, AE: NetworkAPIError>(_ router: NetworkRouter, _ httpErrorType: E.Type = DefaultHTTPErrorBody.self, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Observable<DownloadEvent> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: NetworkError) in
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
    ///   - router: `Router` object used to create request.
    ///   - fileURL: `URL` used to save downloaded file to disk.
    ///   - httpErrorType: `HTTPErrorBody` http error body type.
    ///   - apiErrorType: `NetworkAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating download request.
    public func download<E: HTTPErrorBody, AE: NetworkAPIError>(_ router: NetworkRouter, _ fileURL: URL, _ httpErrorType: E.Type = DefaultHTTPErrorBody.self, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Observable<DownloadEvent> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: NetworkError) in
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
    ///   - router: `Router` object used to create request.
    ///   - file: `UploadFile` object including file details for upload.
    ///   - httpErrorType: `HTTPErrorBody` http error body type.
    ///   - apiErrorType: `NetworkAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating upload request.
    public func upload<T: Decodable, E: HTTPErrorBody, AE: NetworkAPIError>(_ router: NetworkUploadRouter, _ file: UploadFile, _ httpErrorType: E.Type = DefaultHTTPErrorBody.self, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Observable<UploadEvent<T>> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: NetworkError) in
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
    ///   - router: `Router` object used to create request.
    ///   - formData: `UploadFormData` object including parameters and files for upload.
    ///   - httpErrorType: `HTTPErrorBody` http error body type.
    ///   - apiErrorType: `NetworkAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating upload request.
    public func upload<T: Decodable, E: HTTPErrorBody, AE: NetworkAPIError>(_ router: NetworkUploadRouter, _ formData: UploadFormData, _ httpErrorType: E.Type = DefaultHTTPErrorBody.self, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Observable<UploadEvent<T>> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: NetworkError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.session, dueTo: error)
        }
        let observable = session
            .rx
            .uploadResponse(request: adaptedRequest, formData: formData, modelType: T.self, httpErrorType: E.self, apiErrorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
}
