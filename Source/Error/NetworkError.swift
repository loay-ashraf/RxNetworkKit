//
//  NetworkError.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 19/02/2023.
//

import Foundation

/// Generic network error (client, server or api).
public enum NetworkError: Error {
    case client(NetworkClientError)
    case server(NetworkServerError)
    case api(NetworkAPIError)
    
    /// Creates `NetworkError` instance.
    ///
    /// - Parameter response: `HTTPURLResponse` used to get response status code.
    init?<E: HTTPErrorBody>(_ response: HTTPURLResponse?, data: Data?, errorType: E.Type) {
        if let response = response,
           let httpStatusCode = response.status {
            // Get Error body from response data if possible.
            var httpErrorBody: E?
            if let data = data {
                httpErrorBody = try? JSONDecoder().decode(errorType.self, from: data)
            }
            // Get Error from response status code
            switch httpStatusCode.responseType {
            case .clientError:
                self = .client(.http(httpStatusCode, httpErrorBody))
            case .serverError:
                self = .server(.http(httpStatusCode, httpErrorBody))
            default:
                return nil
            }
        } else {
            return nil
        }
    }
    
}
