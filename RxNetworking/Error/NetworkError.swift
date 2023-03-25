//
//  NetworkError.swift
//  RXNetworking
//
//  Created by Loay Ashraf on 19/02/2023.
//

import Foundation

enum NetworkError: Error {
    case client(NetworkClientError)
    case server(NetworkServerError)
    case api(NetworkAPIError)
    /// Creates `NetworkError` instance.
    ///
    /// - Parameter response: `HTTPURLResponse` used to get response status code.
    init?(_ response: HTTPURLResponse?) {
        if let response = response,
           let httpStatusCode = HTTPStatusCode(rawValue: response.statusCode) {
            // Get Error from response status code
            switch httpStatusCode.responseType {
            case .clientError:
                self = .client(.http(httpStatusCode))
            case .serverError:
                self = .server(.http(httpStatusCode))
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
