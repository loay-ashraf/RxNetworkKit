//
//  HTTPRequestLogger.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/01/2024.
//

import Foundation

/// Object responsible for logging outgoing requests and incoming responses.
class HTTPRequestLogger {
    
    /// Shared `HTTPRequestLogger` instance.
    static let shared: HTTPRequestLogger = .init()
    
    /// Private initializer to ensure only one instance is created.
    private init() { }
    
    /// Prints outgoing request to console.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` to be printed to console.
    ///   - bodyPlaceholder: `String?` placeholder to be printed in place of actual body.
    func log(request: URLRequest, bodyPlaceholder: String? = nil) {
        let logMessage = makeLogMessage(for: request, bodyPlaceholder: bodyPlaceholder)
        print(logMessage)
    }
    
    /// Prints incoming response to console.
    ///
    /// - Parameters:
    ///   - response: `(URLResponse?, Data?, Error?)` to be printed to console.
    ///   - bodyPlaceholder: `String?` placeholder to be printed in place of actual body.
    func log(response: (URLResponse?, Data?, Error?), bodyPlaceholder: String? = nil) {
        let logMessage = makeLogMessage(for: response, bodyPlaceholder: bodyPlaceholder)
        print(logMessage)
    }
    
    /// Make console message for outgoing request.
    /// 
    /// - Parameters:
    ///   - request: `URLRequest` to be included in message.
    ///   - bodyPlaceholder: `String?` placeholder to be included in message in place of actual body.
    ///
    /// - Returns: `String` of outgoing request message.
    private func makeLogMessage(for request: URLRequest, bodyPlaceholder: String?) -> String {
        var logMessage: String = ""
        
        logMessage += "* * * * * * * * * * OUTGOING REQUEST * * * * * * * * * *\n"
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = URLComponents(string: urlAsString)
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        var requestDetails = """
       \n\(urlAsString) \n
       \(method) \(path)?\(query) HTTP/1.1 \n
       HOST: \(host)\n
       """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            requestDetails += "\(key): \(value) \n"
        }
        if let bodyPlaceholder = bodyPlaceholder {
            requestDetails += "\n\(bodyPlaceholder)\n"
        } else if let body = request.httpBody {
            if let jsonString = body.json {
                requestDetails += "\n\(jsonString)\n"
            } else {
                requestDetails += "\n\(String(decoding: body, as: UTF8.self))\n"
            }
        }
        
        var curlCommand = """
        \n- - - - - - - - - - - CURL COMMAND - - - - - - - - - - -\n
        """
        curlCommand += "\n\(request.curlCommand)\n"
        
        logMessage += requestDetails
        logMessage += curlCommand
        logMessage += "\n* * * * * * * * * * * * * END * * * * * * * * * * * * *\n"
        
        return logMessage
    }
    
    /// Make console message for incoming response.
    /// 
    /// - Parameters:
    ///   - response: `(URLResponse?, Data?, Error?)` to be included in message.
    ///   - bodyPlaceholder: `String?` placeholder to be included in message in place of actual body.
    ///
    /// - Returns: `String` of incoming response message.
    private func makeLogMessage(for response: (URLResponse?, Data?, Error?), bodyPlaceholder: String?) -> String {
        var logMessage: String = ""
        
        logMessage += "* * * * * * * * * * INCOMING RESPONSE * * * * * * * * * *\n"
        
        let httpResponse = response.0 as? HTTPURLResponse
        let responseBody = response.1
        let responseError = response.2
        
        let urlString = httpResponse?.url?.absoluteString
        let components = URLComponents(string: urlString ?? "")
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        var responseDetails = ""
        if let urlString = urlString {
            responseDetails += "\n\(urlString)"
            responseDetails += "\n\n"
        }
        if let statusCode = httpResponse?.statusCode {
            responseDetails += "HTTP \(statusCode) \(path)?\(query)\n"
        }
        if let host = components?.host {
            responseDetails += "Host: \(host)\n"
        }
        for (key, value) in httpResponse?.allHeaderFields ?? [:] {
            responseDetails += "\(key): \(value)\n"
        }
        if let bodyPlaceholder = bodyPlaceholder {
            responseDetails += "\n\(bodyPlaceholder)\n"
        } else if let body = responseBody {
            if let jsonString = body.json {
                responseDetails += "\n\(jsonString)\n"
            } else {
                responseDetails += "\n\(String(decoding: body, as: UTF8.self))\n"
            }
        }
        if let responseError = responseError {
            responseDetails += "\nError: \(responseError.localizedDescription)\n"
        }
        
        logMessage += responseDetails
        logMessage += "\n* * * * * * * * * * * * * END * * * * * * * * * * * * *\n"
        
        return logMessage
    }
    
}
