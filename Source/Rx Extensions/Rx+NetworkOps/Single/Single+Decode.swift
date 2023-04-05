//
//  Single+Decode.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 27/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

extension PrimitiveSequence where Trait == SingleTrait, Element == (response: HTTPURLResponse, data: Data) {
    /// Creates `Completable` observable.
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
    /// Creates `Single` observable with the same element type.
    ///
    /// - Parameters:
    ///   - errorType: `Decodable` api error type.
    ///
    /// - Returns: `Single` observable to be observed for values.
    func decode<E: NetworkAPIError>(_ errorType: E.Type) -> Single<Element> {
        map {
            let jsonDecoder = JSONDecoder()
            if let apiError = try? jsonDecoder.decode(errorType.self, from: $0.data) {
                let networkError = NetworkError.api(apiError)
                throw networkError
            } else {
                return $0
            }
        }
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
}
