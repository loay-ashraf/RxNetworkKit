//
//  NetworkClientError.swift
//  RXNetworking
//
//  Created by Loay Ashraf on 19/02/2023.
//

import Foundation

enum NetworkClientError: Error {
    case http(HTTPStatusCode)
    case serialization(Error)
    case transport(Error)
}
