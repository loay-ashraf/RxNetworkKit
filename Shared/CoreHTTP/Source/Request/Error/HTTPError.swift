//
//  HTTPError.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 19/02/2023.
//

import Foundation

/// Generic http error (client, server or api).
public enum HTTPError: Error {
    case client(HTTPClientError)
    case server(HTTPServerError)
    case api(HTTPAPIError)
    
    /// Creates `NetworkError` instance.
    ///
    /// - Parameter response: `HTTPURLResponse` used to get response status code.
    public init?<E: HTTPBodyError>(_ response: HTTPURLResponse?, data: Data?, errorType: E.Type) {
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
                self = .client(.response(httpStatusCode, httpErrorBody))
            case .serverError:
                self = .server(.response(httpStatusCode, httpErrorBody))
            default:
                return nil
            }
        } else {
            return nil
        }
    }
    
}
