//
//  NetworkClientError.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 19/02/2023.
//

/// Client-side (transport) error
enum NetworkClientError: Error {
    case http(HTTPStatusCode)
    case serialization(Error)
    case transport(Error)
}
