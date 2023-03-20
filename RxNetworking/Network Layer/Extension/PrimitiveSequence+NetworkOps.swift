//
//  PrimitiveSequence+NetworkOps.swift
//  RXNetworking
//
//  Created by Loay Ashraf on 19/02/2023.
//

import Foundation
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == (response: HTTPURLResponse, data: Data) {
    /// Creates `Completable` observable from data.
    ///
    /// - Parameters:
    ///   - errorType: `Decodable` api error type.
    ///
    /// - Returns: `Completable` observable to be observed for values.
    func decode<E: NetworkAPIError>(_ errorType: E.Type) -> Completable {
        map {
            let jsonDecoder = JSONDecoder()
            if let apiError = try? jsonDecoder.decode(errorType.self, from: $0.data) {
                let networkError = NetworkError.api(apiError)
                throw networkError
            } else {
                return $0
            }
        }
        .asCompletable()
    }
    /// Creates `Single` observable with Decodable element type from data.
    ///
    /// - Parameters:
    ///   - modelType: `Decodable` model type.
    ///   - errorType: `Decodable` api error type.
    ///
    /// - Returns: `Single` observable to be observed for values.
    func decode<M: Decodable, E: NetworkAPIError>(_ modelType: M.Type, errorType: E.Type) -> Single<M> {
        map {
            let jsonDecoder = JSONDecoder()
            do {
                let model = try jsonDecoder.decode(modelType.self, from: $0.data)
                return model
            } catch {
                let apiError = try jsonDecoder.decode(errorType.self, from: $0.1)
                let networkError = NetworkError.api(apiError)
                throw networkError
            }
        }
    }
    /// Verifies response's status code.
    ///
    /// - Returns: `Single` observable to be observed for values.
    func verifyResponse() -> Single<Element> {
        map { (response: HTTPURLResponse, data: Data) in
            if let networkError = NetworkError.init(response) {
                throw networkError
            } else {
                return (response, data)
            }
        }
    }
    /// Catches transport errors and wraps them in `NetworkError` type.
    ///
    /// - Returns: `Single` observable to be observed for values.
    func catchTransportError() -> Single<Element> {
        self.catch {
            let clientError = NetworkClientError.transport($0)
            throw NetworkError.client(clientError)
        }
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element: Decodable {
    /// Catches serialization errors and wraps them in `NetworkError` type.
    ///
    /// - Returns: `Single` observable to be observed for values.
    func catchSerializationError() -> Single<Element> {
        self.catch {
            if $0 is NetworkError, !($0 is DecodingError) {
                throw $0
            } else {
                let clientError = NetworkClientError.serialization($0)
                throw NetworkError.client(clientError)
            }
        }
    }
}
