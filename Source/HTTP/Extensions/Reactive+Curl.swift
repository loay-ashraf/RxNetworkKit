//
//  Reactive+Curl.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: URLSession {
    /// escapes terminal substring in given string.
    ///
    /// - Parameter value: `String` to escape terminal substring in it.
    ///
    /// - Returns: string with escaped terminal substring.
    func escapeTerminalString(_ value: String) -> String {
        return value.replacingOccurrences(of: "\"", with: "\\\"", options:[], range: nil)
    }
    /// converts given `URLRequest` to curl command.
    ///
    /// - Parameter request: `URLRequest` to be converted to curl command.
    ///
    /// - Returns: result curl command from `URLRequest`convertion.
    func convertURLRequestToCurlCommand(_ request: URLRequest) -> String {
        let method = request.httpMethod ?? "GET"
        var returnValue = "curl -X \(method) "
        if let httpBody = request.httpBody {
            let maybeBody = String(data: httpBody, encoding: String.Encoding.utf8)
            if let body = maybeBody {
                returnValue += "-d \"\(escapeTerminalString(body))\" "
            }
        }
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            let escapedKey = escapeTerminalString(key as String)
            let escapedValue = escapeTerminalString(value as String)
            returnValue += "\n    -H \"\(escapedKey): \(escapedValue)\" "
        }
        let URLString = request.url?.absoluteString ?? "<unknown url>"
        returnValue += "\n\"\(escapeTerminalString(URLString))\""
        returnValue += " -i -v"
        return returnValue
    }
    /// converts `URLResponse` to string.
    ///
    /// - Parameters:
    ///   - response: `URLResponse` to be converted to string
    ///   - error: `NSError` error returned in response.
    ///   - interval: `TimeInterval` taken by request to complete.
    ///
    /// - Returns: result string from `URLResponse`conversion.
    func convertResponseToString(_ response: URLResponse?, _ error: NSError?, _ interval: TimeInterval) -> String {
        let ms = Int(interval * 1000)
        if let response = response as? HTTPURLResponse {
            if 200 ..< 300 ~= response.statusCode {
                return "Success (\(ms)ms): Status \(response.statusCode)"
            } else {
                return "Failure (\(ms)ms): Status \(response.statusCode)"
            }
        }
        if let error = error {
            if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
                return "Canceled (\(ms)ms)"
            }
            return "Failure (\(ms)ms): NSError > \(error)"
        }
        return "<Unhandled response from server>"
    }
}
