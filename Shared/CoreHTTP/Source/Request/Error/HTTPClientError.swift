//
//  HTTPClientError.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 19/02/2023.
//

/// Client-side (transport) http error.
public enum HTTPClientError: Error {
    case response(HTTPStatusCode, HTTPBodyError?)
    case serialization(Error)
    case transport(Error)
}
