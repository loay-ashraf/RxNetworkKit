//
//  Reactive+URLSessionAdaptedDownloadResponse.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/03/2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

extension Reactive where Base: URLSession {
    /// Creates an observable with `DownloadEvent` type.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create upload task and its observables.
    ///   - httpErrorType: `HTTPBodyError` http body error type.
    ///   - apiErrorType: `HTTPAPIError` type for expected error in HTTP response body.
    ///
    /// - Returns: a `Observable` object of `DownloadEvent` type.
    func downloadResponse<E: HTTPBodyError, AE: HTTPAPIError>(request: URLRequest, httpErrorType: E.Type, apiErrorType: AE.Type) -> Observable<HTTPDownloadRequestEvent> {
        let observables = downloadResponse(request: request)
        let progressObservable = observables
            .0
            .map { HTTPDownloadRequestEvent.progress(progress: $0) }
            .asObservable()
        let responseObservable = observables
            .1
            .decodable(E.self, apiErrorType: AE.self)
            .map { HTTPDownloadRequestEvent.completedWithData(data: $0.data) }
            .asObservable()
        let mergedObservable = responseObservable.merge(with: progressObservable)
        return mergedObservable
    }
    /// Creates an observable with `DownloadEvent` type.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create upload task and its observables.
    ///   - url: `URL` used to save downloaded file to disk.
    ///   - httpErrorType: `HTTPBodyError` http body error type.
    ///   - apiErrorType: `HTTPAPIError` type for expected error in HTTP response body.
    ///
    /// - Returns: a `Observable` object of `DownloadEvent` type.
    func downloadResponse<E: HTTPBodyError, AE: HTTPAPIError>(request: URLRequest, saveTo url: URL, httpErrorType: E.Type, apiErrorType: AE.Type) -> Observable<HTTPDownloadRequestEvent> {
        let observables = downloadResponse(request: request, saveTo: url)
        let progressObservable = observables
            .0
            .map { HTTPDownloadRequestEvent.progress(progress: $0) }
            .asObservable()
        let responseObservable = observables
            .1
            .decodable(E.self, apiErrorType: AE.self)
            .map { _ in HTTPDownloadRequestEvent.completed }
            .asObservable()
        let mergedObservable = responseObservable.merge(with: progressObservable)
        return mergedObservable
    }
}
