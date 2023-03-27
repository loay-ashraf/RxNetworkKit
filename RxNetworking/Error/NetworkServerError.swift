//
//  NetworkServerError.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 19/02/2023.
//

/// Server-side error
enum NetworkServerError: Error {
    case http(HTTPStatusCode)
    case generic(Error)
}
