//
//  NetworkClientError.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 19/02/2023.
//

/// Client-side (transport) network error.
public enum NetworkClientError: Error {
    case http(HTTPStatusCode, HTTPErrorBody?)
    case serialization(Error)
    case transport(Error)
}
