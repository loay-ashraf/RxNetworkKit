//
//  Single+CatchErrors.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 27/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

extension PrimitiveSequence where Trait == SingleTrait, Element == (response: HTTPURLResponse, data: Data) {
    /// Catches transport errors and wraps them in `NetworkError` type.
    ///
    /// - Returns: `Single` observable to be observed for values.
    func catchTransportError() -> Single<Element> {
        self.catch {
            let clientError = HTTPClientError.transport($0)
            throw HTTPError.client(clientError)
        }
    }
}
extension PrimitiveSequence where Trait == SingleTrait, Element: Decodable {
    /// Catches serialization errors and wraps them in `NetworkError` type.
    ///
    /// - Returns: `Single` observable to be observed for values.
    func catchSerializationError() -> Single<Element> {
        self.catch {
            if $0 is HTTPError, !($0 is DecodingError) {
                throw $0
            } else {
                let clientError = HTTPClientError.serialization($0)
                throw HTTPError.client(clientError)
            }
        }
    }
}
