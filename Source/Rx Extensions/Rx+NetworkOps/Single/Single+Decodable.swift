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
    ///   - errorType: `Decodable` api error type.
    ///
    /// - Returns: Observable to be observed for values.
    func decodable<E: NetworkAPIError>(_ errorType: E.Type) -> Completable {
        self
            // catch any transport errors if thrown.
            .catchTransportError()
            // verify response status code.
            .verifyResponse()
            // serialize data into given error type and throw it.
            .decode(E.self)
    }
    /// Creates `Single` observable with the same element type + handles transport errors.
    ///
    /// - Parameters:
    ///   - errorType: `Decodable` api error type.
    ///
    /// - Returns: Observable to be observed for values.
    func decodable<E: NetworkAPIError>(_ errorType: E.Type) -> Single<Element> {
        self
            // catch any transport errors if thrown.
            .catchTransportError()
            // verify response status code.
            .verifyResponse()
            // serialize data into given error type and throw it.
            .decode(E.self)
    }
    /// Creates  `Single` observable with Decodable element type + handles transport and serialization errors.
    ///
    /// - Parameters:
    ///   - modelType: `Decodable` model type.
    ///   - errorType: `Decodable` api error type.
    ///
    /// - Returns: Observable to be observed for values.
    func decodable<M: Decodable, E: NetworkAPIError>(_ modelType: M.Type, errorType: E.Type) -> Single<M> {
        self
            // catch any transport errors if thrown.
            .catchTransportError()
            // verify response status code.
            .verifyResponse()
            // serialize data into given model type or error type if serialization failed.
            .decode(M.self, errorType: E.self)
            // catch any serialization errors if found.
            .catchSerializationError()
    }
}
