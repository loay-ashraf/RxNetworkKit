//
//  Reactive+URLSessionAdaptedResponse.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 22/03/2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

extension Reactive where Base: URLSession {
    /// Creates an observable with `UploadEvent` type.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create upload task and its observables.
    ///   - file: `UploadFile` object to be uploaded.
    ///   - modelType: `Decodable` type for model  in HTTP response body.
    ///   - httpErrorType: `HTTPErrorBody` http error body type.
    ///   - apiErrorType: `NetworkAPIError` type for expected error in HTTP response body.
    ///
    /// - Returns: a `Observable` object of `UploadEvent` type.
    func uploadResponse<T: Decodable, E: HTTPBodyError, AE: HTTPAPIError>(request: URLRequest, file: HTTPUploadRequestFile, modelType: T.Type, httpErrorType: E.Type, apiErrorType: AE.Type) -> Observable<HTTPUploadRequestEvent<T>> {
        let observables = uploadResponse(request: request, file: file)
        let progressObservable = observables
            .0
            .map { HTTPUploadRequestEvent<T>.progress(progress: $0) }
            .asObservable()
        let responseObservable = observables
            .1
            .decodable(T.self, httpErrorType: E.self, apiErrorType: AE.self)
            .map { HTTPUploadRequestEvent<T>.completed(model: $0) }
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
    ///   - httpErrorType: `HTTPErrorBody` http error body type.
    ///   - apiErrorType: `NetworkAPIError` type for expected error in HTTP response body.
    ///
    /// - Returns: a `Observable` object of `UploadEvent` type.
    func uploadResponse<T: Decodable, E: HTTPBodyError, AE: HTTPAPIError>(request: URLRequest, formData: HTTPUploadRequestFormData, modelType: T.Type, httpErrorType: E.Type, apiErrorType: AE.Type) -> Observable<HTTPUploadRequestEvent<T>> {
        let observables = uploadResponse(request: request, formData: formData)
        let progressObservable = observables
            .0
            .map { HTTPUploadRequestEvent<T>.progress(progress: $0) }
            .asObservable()
        let responseObservable = observables
            .1
            .decodable(T.self, httpErrorType: E.self, apiErrorType: AE.self)
            .map { HTTPUploadRequestEvent<T>.completed(model: $0) }
            .asObservable()
        let mergedObservable = responseObservable.merge(with: progressObservable)
        return mergedObservable
    }
}
