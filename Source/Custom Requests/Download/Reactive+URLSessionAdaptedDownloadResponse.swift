//
//  Reactive+URLSessionAdaptedDownloadResponse.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: URLSession {
    /// Creates an observable with `DownloadEvent` type.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create upload task and its observables.
    ///   - httpErrorType: `HTTPErrorBody` http error body type.
    ///   - apiErrorType: `NetworkAPIError` type for expected error in HTTP response body.
    ///
    /// - Returns: a `Observable` object of `DownloadEvent` type.
    func downloadResponse<E: HTTPErrorBody, AE: NetworkAPIError>(request: URLRequest, httpErrorType: E.Type, apiErrorType: AE.Type) -> Observable<DownloadEvent> {
        let observables = downloadResponse(request: request)
        let progressObservable = observables
            .0
            .map { DownloadEvent.progress(progress: $0) }
            .asObservable()
        let responseObservable = observables
            .1
            .decodable(E.self, apiErrorType: AE.self)
            .map { DownloadEvent.completedWithData(data: $0.data) }
            .asObservable()
        let mergedObservable = responseObservable.merge(with: progressObservable)
        return mergedObservable
    }
    /// Creates an observable with `DownloadEvent` type.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create upload task and its observables.
    ///   - url: `URL` used to save downloaded file to disk.
    ///   - httpErrorType: `HTTPErrorBody` http error body type.
    ///   - apiErrorType: `NetworkAPIError` type for expected error in HTTP response body.
    ///
    /// - Returns: a `Observable` object of `DownloadEvent` type.
    func downloadResponse<E: HTTPErrorBody, AE: NetworkAPIError>(request: URLRequest, saveTo url: URL, httpErrorType: E.Type, apiErrorType: AE.Type) -> Observable<DownloadEvent> {
        let observables = downloadResponse(request: request, saveTo: url)
        let progressObservable = observables
            .0
            .map { DownloadEvent.progress(progress: $0) }
            .asObservable()
        let responseObservable = observables
            .1
            .decodable(E.self, apiErrorType: AE.self)
            .map { _ in DownloadEvent.completed }
            .asObservable()
        let mergedObservable = responseObservable.merge(with: progressObservable)
        return mergedObservable
    }
}
