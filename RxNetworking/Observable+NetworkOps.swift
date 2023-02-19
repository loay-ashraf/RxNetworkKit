//
//  Observable+NetworkOps.swift
//  RXNetworking
//
//  Created by Loay Ashraf on 19/02/2023.
//

import Foundation
import RxSwift

extension Observable where Element == (response: HTTPURLResponse, data: Data) {
    /// Creates observable with Decodable element type + handles transport and serialization erros.
    ///
    /// - Parameters:
    ///   - modelType: `Decodable` model type.
    ///   - errorType: `Decodable` api error type.
    ///
    /// - Returns: Observable to be observed for values.
    func decodable<M: Decodable, E: NetworkAPIError>(_ modelType: M.Type, errorType: E.Type) -> Single<M> {
        asSingle()
            // catch any transport errors if found.
            .catchTransportError()
            // verify response status code.
            .verifyResponse()
            // serialize data into given model type or error type if serialization failed.
            .decode(M.self, errorType: E.self)
            // catch any serialization errors if found.
            .catchSerializationError()
    }
}
