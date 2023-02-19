//
//  NetworkServerError.swift
//  RXNetworking
//
//  Created by Loay Ashraf on 19/02/2023.
//

import Foundation

enum NetworkServerError: Error {
    case http(HTTPStatusCode)
    case generic(Error)
}
