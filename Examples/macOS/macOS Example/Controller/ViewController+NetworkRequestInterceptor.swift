//
//  ViewController+NetworkRequestInterceptor.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/04/2023.
//

import Foundation
import RxNetworkKit

extension ViewController: HTTPRequestInterceptor {
    func adapt(_ request: URLRequest, for session: URLSession) -> URLRequest {
        return request
    }
    func retryMaxAttempts(_ request: URLRequest, for session: URLSession) -> Int {
        5
    }
    func retryPolicy(_ request: URLRequest, for session: URLSession) -> HTTPRequestRetryPolicy {
        .constant(time: 5_000)
    }
    func shouldRetry(_ request: URLRequest, for session: URLSession, dueTo error: HTTPError) -> Bool {
        true
    }
}
