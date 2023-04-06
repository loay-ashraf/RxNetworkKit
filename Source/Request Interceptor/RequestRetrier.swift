//
//  RequestRetrier.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 27/03/2023.
//

import Foundation

public protocol NetworkRequestRetrier {
    func retryMaxAttempts(_ request: URLRequest, for session: URLSession) -> Int
    func retryPolicy(_ request: URLRequest, for session: URLSession) -> NetworkRequestRetryPolicy
    func shouldRetry(_ request: URLRequest, for session: URLSession, dueTo error: NetworkError) -> Bool
}
