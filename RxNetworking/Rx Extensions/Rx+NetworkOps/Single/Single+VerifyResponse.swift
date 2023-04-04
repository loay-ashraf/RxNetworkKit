//
//  Single+VerifyResponse.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 27/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

extension PrimitiveSequence where Trait == SingleTrait, Element == (response: HTTPURLResponse, data: Data) {
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
}