//
//  Reactive+URLSessionAdaptedResponse.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 22/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: URLSession {
    /// Creates an observable with `UploadEvent` type.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create upload task and its observables.
    ///   - file: `UploadFile` object to be uploaded.
    ///   - modelType: `Decodable` type for model  in HTTP response body.
    ///   - apiErrorType: `NetworkAPIError` type for expected error in HTTP response body.
    ///
    /// - Returns: a `Observable` object of `UploadEvent` type.
    func uploadResponse<T: Decodable, AE: NetworkAPIError>(request: URLRequest, file: UploadFile, modelType: T.Type, apiErrorType: AE.Type) -> Observable<UploadEvent<T>> {
        let observables = uploadResponse(request: request, file: file)
        let progressObservable = observables
            .0
            .map { UploadEvent<T>.progress(progress: $0) }
            .asObservable()
        let responseObservable = observables
            .1
            .decodable(T.self, errorType: AE.self)
            .map { UploadEvent<T>.completed(model: $0) }
            .asObservable()
        let mergedObservable = responseObservable.merge(with: progressObservable)
        return mergedObservable
    }
    /// Creates an observable with `UploadEvent` type.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create upload task and its observables.
    ///   - formData: `UploadFormData` object that includes parameters and files to be uploaded.
    ///   - modelType: `Decodable` type for model  in HTTP response body.
    ///   - apiErrorType: `NetworkAPIError` type for expected error in HTTP response body.
    ///
    /// - Returns: a `Observable` object of `UploadEvent` type.
    func uploadResponse<T: Decodable, AE: NetworkAPIError>(request: URLRequest, formData: UploadFormData, modelType: T.Type, apiErrorType: AE.Type) -> Observable<UploadEvent<T>> {
        let observables = uploadResponse(request: request, formData: formData)
        let progressObservable = observables
            .0
            .map { UploadEvent<T>.progress(progress: $0) }
            .asObservable()
        let responseObservable = observables
            .1
            .decodable(T.self, errorType: AE.self)
            .map { UploadEvent<T>.completed(model: $0) }
            .asObservable()
        let mergedObservable = responseObservable.merge(with: progressObservable)
        return mergedObservable
    }
}
