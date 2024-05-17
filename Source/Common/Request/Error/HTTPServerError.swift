//
//  HTTPServerError.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 19/02/2023.
//

/// Server-side http error.
public enum HTTPServerError: Error {
    case response(HTTPStatusCode, HTTPBodyError?)
    case generic(Error)
}
