//
//  HTTPLogger.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/01/2024.
//

import Foundation

/// Object responsible for logging outgoing requests and incoming responses.
final class HTTPLogger {
    
    /// Shared `HTTPLogger` instance.
    static let shared: HTTPLogger = .init()
    
    /// Private initializer to ensure only one instance is created.
    private init() { }
    
    /// Prints outgoing request to console.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` to be printed to console.
    ///   - bodyPlaceholder: `String?` placeholder to be printed in place of actual body.
    func log(request: URLRequest, bodyLogMessage: String? = nil, curlBodyOption: String? = nil) {
        let logMessage = makeLogMessage(for: request, bodyLogMessage: bodyLogMessage, curlBodyOption: curlBodyOption)
        print(logMessage)
    }
    
    /// Prints incoming response to console.
    ///
    /// - Parameters:
    ///   - responseArguments: `(URL?, URLResponse?, Data?, Error?)` to be printed to console.
    ///   - bodyPlaceholder: `String?` placeholder to be printed in place of actual body.
    func log(responseArguments: (URL?, Data?, URLResponse?, Error?), bodyLogMessage: String? = nil) {
        let logMessage = makeLogMessage(for: responseArguments, bodyLogMessage: bodyLogMessage)
        print(logMessage)
    }
    
    /// Makes console message for outgoing request.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` to be included in message.
    ///   - bodyLogMessage: `String?` placeholder to be included in message in place of actual body.
    ///
    /// - Returns: `String` of outgoing request message.
    private func makeLogMessage(for request: URLRequest, bodyLogMessage: String?, curlBodyOption: String? = nil) -> String {
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
        if let bodyLogMessage = bodyLogMessage {
            requestDetails += "\n\(bodyLogMessage)\n"
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
        curlCommand += "\n\(request.curlCommand(bodyOption: curlBodyOption))\n"
        
        logMessage += requestDetails
        logMessage += curlCommand
        logMessage += "\n* * * * * * * * * * * * * END * * * * * * * * * * * * *\n"
        
        return logMessage
    }
    
    /// Makes console message for incoming response.
    /// 
    /// - Parameters:
    ///   - response: `(URL?, URLResponse?, Data?, Error?)` to be included in message.
    ///   - bodyLogMessage: `String?` placeholder to be included in message in place of actual body.
    ///
    /// - Returns: `String` of incoming response message.
    private func makeLogMessage(for responseArguments: (URL?, Data?, URLResponse?, Error?), bodyLogMessage: String?) -> String {
        var logMessage: String = ""
        
        logMessage += "* * * * * * * * * * INCOMING RESPONSE * * * * * * * * * *\n"
        
        let url = responseArguments.0
        let httpResponse = responseArguments.2 as? HTTPURLResponse
        let responseBody = responseArguments.1
        let responseError = responseArguments.3
        
        
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
        if let bodyLogMessage = bodyLogMessage,
           responseError == nil {
            responseDetails += "\n\(bodyLogMessage)\n"
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
