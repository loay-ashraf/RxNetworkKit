//
//  RequestInterceptor.swift
//  CoreExample
//
//  Created by Loay Ashraf on 12/10/2023.
//

public class RequestInterceptor: HTTPRequestInterceptor {
    public init() { }
    public func adapt(_ request: URLRequest, for session: URLSession) -> URLRequest {
        return request
    }
    public func retryMaxAttempts(_ request: URLRequest, for session: URLSession) -> Int {
        5
    }
    public func retryPolicy(_ request: URLRequest, for session: URLSession) -> HTTPRequestRetryPolicy {
        .constant(time: 5_000)
    }
    public func shouldRetry(_ request: URLRequest, for session: URLSession, dueTo error: HTTPError) -> Bool {
        true
    }
}
