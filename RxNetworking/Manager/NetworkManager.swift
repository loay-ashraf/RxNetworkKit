//
//  NetworkManager.swift
//  RXNetworking
//
//  Created by Loay Ashraf on 16/02/2023.
//

import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa
import Combine

class NetworkManager {
    private let session: URLSession
    /// Creates `NetworkManager` instance.
    ///
    /// - Parameter session: `Session` object used in performing network requests.
    init(session: URLSession) {
        self.session = session
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
        let urlRequest = router.asURLRequest()
        let observable = session
            .rx
            .response(request: urlRequest)
            .decodable(AE.self)
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
        let urlRequest = router.asURLRequest()
        let observable = session
            .rx
            .response(request: urlRequest)
            .decodable(T.self, errorType: AE.self)
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
        let urlRequest = router.asURLRequest()
        let observable = session
            .rx
            .downloadResponse(request: urlRequest, apiErrorType: AE.self)
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
        let urlRequest = router.asURLRequest()
        let observable = session
            .rx
            .downloadResponse(request: urlRequest, saveTo: fileURL, apiErrorType: AE.self)
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
        let urlRequest = router.asURLRequest()
        let observable = session
            .rx
            .uploadResponse(request: urlRequest, file: file, modelType: T.self, apiErrorType: AE.self)
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
        let urlRequest = router.asURLRequest()
        let observable = session
            .rx
            .uploadResponse(request: urlRequest, formData: formData, modelType: T.self, apiErrorType: AE.self)
        return observable
    }
}
