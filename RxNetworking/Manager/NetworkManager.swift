//
//  NetworkManager.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 16/02/2023.
//

import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa

class NetworkManager {
    private let session: URLSession
    private let requestInterceptor: NetworkRequestInterceptor
    private let eventMonitor: NetworkEventMonitor
    /// Creates `NetworkManager` instance.
    ///
    /// - Parameters:
    ///   - configuration: `URLSessionConfiguration` object used to create `URLSession` instance.
    ///   - requestInterceptor: `NetworkRequestInterceptor` object used for intercepting requests.
    ///   - eventMonitor: `NetworkEventMonitor` object for monitoring events for session.
    init(configuration: URLSessionConfiguration, requestInterceptor: NetworkRequestInterceptor, eventMonitor: NetworkEventMonitor) {
        self.session = .init(configuration: configuration, delegate: eventMonitor, delegateQueue: nil)
        self.requestInterceptor = requestInterceptor
        self.eventMonitor = eventMonitor
    }
    /// Creates a `Completable` observable encapsulating data request using given `Router`.
    /// Use this method if you are expecting empty response body.
    ///
    /// - Parameters:
    ///   - router: `Router` object used to create request.
    ///   - apiErrorType: `NetworkAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Completable` observable encapsulating data request.
    func request<AE: NetworkAPIError>(_ router: NetworkRouter, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Completable {
        
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
            .decodable(AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
    /// Creates a `Single` observable encapsulating data request using given `Router`.
    /// Use this method if you are expecting data in response body.
    ///
    /// - Parameters:
    ///   - router: `Router` object used to create request.
    ///   - apiErrorType: `NetworkAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Single` observable encapsulating data request.
    func request<T: Decodable, AE: NetworkAPIError>(_ router: NetworkRouter, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Single<T> {
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
            .decodable(T.self, errorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
    /// Creates a `Observable` object encapsulating download request using given `Router`.
    /// Use this method if you are downloading a relatively small file (keeps data in memory).
    ///
    /// - Parameters:
    ///   - router: `Router` object used to create request.
    ///   - apiErrorType: `NetworkAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating download request.
    func download<AE: NetworkAPIError>(_ router: NetworkRouter, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Observable<DownloadEvent> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: NetworkError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.session, dueTo: error)
        }
        let observable = session
            .rx
            .downloadResponse(request: adaptedRequest, apiErrorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
    /// Creates a `Observable` object encapsulating download request using given `Router`.
    /// Use this method if you are downloading a relatively small file (saves file to disk).
    ///
    /// - Parameters:
    ///   - router: `Router` object used to create request.
    ///   - fileURL: `URL` used to save downloaded file to disk.
    ///   - apiErrorType: `NetworkAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating download request.
    func download<AE: NetworkAPIError>(_ router: NetworkRouter, _ fileURL: URL, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Observable<DownloadEvent> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: NetworkError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.session, dueTo: error)
        }
        let observable = session
            .rx
            .downloadResponse(request: adaptedRequest, saveTo: fileURL, apiErrorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
    /// Creates a `Observable` object encapsulating upload request using given `Router`.
    /// Use this method if you are uploading single file at a time.
    ///
    /// - Parameters:
    ///   - router: `Router` object used to create request.
    ///   - file: `UploadFile` object including file details for upload.
    ///   - apiErrorType: `NetworkAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating upload request.
    func upload<T: Decodable, AE: NetworkAPIError>(_ router: NetworkUploadRouter, _ file: UploadFile, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Observable<UploadEvent<T>> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: NetworkError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.session, dueTo: error)
        }
        let observable = session
            .rx
            .uploadResponse(request: adaptedRequest, file: file, modelType: T.self, apiErrorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
    /// Creates a `Observable` object encapsulating upload request using given `Router`.
    /// Use this method if you are uploading multiple files at a time.
    ///
    /// - Parameters:
    ///   - router: `Router` object used to create request.
    ///   - formData: `UploadFormData` object including parameters and files for upload.
    ///   - apiErrorType: `NetworkAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating upload request.
    func upload<T: Decodable, AE: NetworkAPIError>(_ router: NetworkUploadRouter, _ formData: UploadFormData, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Observable<UploadEvent<T>> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: session)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: session)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: session)
        let shouldRetry = { (error: NetworkError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.session, dueTo: error)
        }
        let observable = session
            .rx
            .uploadResponse(request: adaptedRequest, formData: formData, modelType: T.self, apiErrorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
}
