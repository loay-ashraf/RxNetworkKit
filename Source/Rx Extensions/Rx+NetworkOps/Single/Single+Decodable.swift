//
//  Single+Decodable.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 27/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

extension PrimitiveSequence where Trait == SingleTrait, Element == (response: HTTPURLResponse, data: Data) {
    /// Creates `Completable` observable + handles transport errors.
    ///
    /// - Parameters:
    ///   - httpErrorType: `Decodable` http error body type.
    ///   - apiErrorType: `Decodable` api error type.
    ///
    /// - Returns: Observable to be observed for values.
    func decodable<E: HTTPErrorBody, AE: NetworkAPIError>(_ httpErrorType: E.Type, apiErrorType: AE.Type) -> Completable {
        self
            // catch any transport errors if thrown.
            .catchTransportError()
            // verify response status code and decode error body if possible.
            .verifyResponse(E.self)
            // serialize data into given error type and throw it.
            .decode(AE.self)
    }
    /// Creates `Single` observable with the same element type + handles transport errors.
    ///
    /// - Parameters:
    ///   - httpErrorType: `Decodable` http error body type.
    ///   - apiErrorType: `Decodable` api error type.
    ///
    /// - Returns: Observable to be observed for values.
    func decodable<E: HTTPErrorBody, AE: NetworkAPIError>(_ httpErrorType: E.Type, apiErrorType: AE.Type) -> Single<Element> {
        self
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
    ///   - httpErrorType: `Decodable` http error body type.
    ///   - apiErrorType: `Decodable` api error type.
    ///
    /// - Returns: Observable to be observed for values.
    func decodable<M: Decodable, E: HTTPErrorBody, AE: NetworkAPIError>(_ modelType: M.Type, httpErrorType: E.Type, apiErrorType: AE.Type) -> Single<M> {
        self
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
