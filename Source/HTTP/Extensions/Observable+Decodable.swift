//
//  Observable+Decodable.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 19/02/2023.
//

import Foundation
import RxSwift

extension Observable where Element == (response: HTTPURLResponse, data: Data) {
    /// Creates `Completable` observable + handles transport errors.
    ///
    /// - Parameters:
    ///   - httpErrorType: `Decodable` http body error type.
    ///   - apiErrorType: `Decodable` api error type.
    ///
    /// - Returns: Observable to be observed for values.
    func decodable<E: HTTPBodyError, AE: HTTPAPIError>(_ httpErrorType: E.Type, apiErrorType: AE.Type) -> Completable {
        asSingle()
            // catch any transport errors if thrown.
            .catchTransportError()
            // verify response status code and decode error body if possible.
            .verifyResponse(E.self)
            // serialize data into given error type and throw it.
            .decode(AE.self)
    }
    /// Creates  `Single` observable with Decodable element type + handles transport and serialization errors.
    ///
    /// - Parameters:
    ///   - modelType: `Decodable` model type.
    ///   - httpErrorType: `Decodable` http body error type.
    ///   - apiErrorType: `Decodable` api error type.
    ///
    /// - Returns: Observable to be observed for values.
    func decodable<M: Decodable, E: HTTPBodyError, AE: HTTPAPIError>(_ modelType: M.Type, httpErrorType: E.Type, apiErrorType: AE.Type) -> Single<M> {
        asSingle()
            // catch any transport errors if thrown.
            .catchTransportError()
            // verify response status code and decode error body if possible.
            .verifyResponse(E.self)
            // serialize data into given model type or error type if serialization failed.
            .decode(M.self, errorType: AE.self)
            // catch any serialization errors if found.
            .catchSerializationError()
    }
}
