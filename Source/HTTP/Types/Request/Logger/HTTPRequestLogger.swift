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
    ///   - response: `(URL?, URLResponse?, Data?, Error?)` to be printed to console.
    ///   - bodyPlaceholder: `String?` placeholder to be printed in place of actual body.
    func log(response: (URL?, URLResponse?, Data?, Error?), bodyPlaceholder: String? = nil) {
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
        
        let urlString = request.url?.absoluteString ?? ""
        let urlComponents = URLComponents(string: urlString)
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var requestDetails = """
       \n\(urlString) \n
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
    ///   - response: `(URL?, URLResponse?, Data?, Error?)` to be included in message.
    ///   - bodyPlaceholder: `String?` placeholder to be included in message in place of actual body.
    ///
    /// - Returns: `String` of incoming response message.
    private func makeLogMessage(for response: (URL?, URLResponse?, Data?, Error?), bodyPlaceholder: String?) -> String {
        var logMessage: String = ""
        
        logMessage += "* * * * * * * * * * INCOMING RESPONSE * * * * * * * * * *\n"
        
        let url = response.0
        let httpResponse = response.1 as? HTTPURLResponse
        let responseBody = response.2
        let responseError = response.3
        
        
        let urlString = url?.absoluteString ?? ""
        let urlComponents = URLComponents(string: urlString)
        let host = "\(urlComponents?.host ?? "")"
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        
        var responseDetails = ""
        
        responseDetails += "\n\(urlString)"
        responseDetails += "\n\n"
        
        if let statusCode = httpResponse?.statusCode {
            responseDetails += "HTTP \(statusCode) \(path)?\(query)\n"
        }
        
        responseDetails += "Host: \(host)\n"
        
        for (key, value) in httpResponse?.allHeaderFields ?? [:] {
            responseDetails += "\(key): \(value)\n"
        }
        if let bodyPlaceholder = bodyPlaceholder,
           responseError == nil {
            responseDetails += "\n\(bodyPlaceholder)\n"
        } else if let body = responseBody {
            if let jsonString = body.json {
                responseDetails += "\n\(jsonString)\n"
            } else {
                responseDetails += "\n\(String(decoding: body, as: UTF8.self))\n"
            }
        }
        if let responseError = responseError {
            let errorCode = (responseError as NSError).code
            if errorCode == -999,
               TLSTrustEvaluator.getBlockedHosts().contains(host) {
                responseDetails += "\nError: TLS trust evaluation failed for the specified host, you may need to update the pinned certificates or public keys.\n"
            } else {
                responseDetails += "\nError: \(responseError.localizedDescription)\n"
            }
            
        }
        
        logMessage += responseDetails
        logMessage += "\n* * * * * * * * * * * * * END * * * * * * * * * * * * *\n"
        
        return logMessage
    }
    
}
