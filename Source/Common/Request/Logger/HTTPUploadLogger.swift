//
//  HTTPUploadLogger.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/05/2024.
//

import Foundation

final class HTTPUploadLogger {
    
    /// Shared `HTTPUploadLogger` instance.
    static let shared: HTTPUploadLogger = .init()
    
    /// Private initializer to ensure only one instance is created.
    private init() { }
    
    /// Prints outgoing request to console.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` to be printed to console.
    ///   - file: `HTTPUploadRequestFile` file details to be printed in place of body.
    func log(request: URLRequest, file: HTTPUploadRequestFile) {
        let bodyLogMessage = makeBodyLogMessage(for: file)
        let curlBodyOption = makeCURLBodyOption(for: file)
        HTTPLogger.shared.log(request: request, bodyLogMessage: bodyLogMessage, curlBodyOption: curlBodyOption)
    }
    
    /// Prints incoming response to console.
    ///
    /// - Parameters:
    ///   - responseArguments: `(URL?, Data?, URLResponse?, Error?)` to be printed to console.
    func log(responseArguments: (URL?, Data?, URLResponse?, Error?)) {
        HTTPLogger.shared.log(responseArguments: responseArguments)
    }
    
    /// Makes console body message for outgoing request.
    ///
    /// - Parameters:
    ///   - file: `HTTPUploadRequestFile` file details to be printed in place of body.
    ///
    /// - Returns: `String` of outgoing request body message.
    private func makeBodyLogMessage(for file: HTTPUploadRequestFile) -> String {
        var bodyLogMessage: String = ""
        
        if let filePath = file.path {
            let fileName = file.name
            let fileType = file.mimeType.rawValue
            let fileSize = file.size.formattedSize
            bodyLogMessage += "{ File From Disk }\n"
            bodyLogMessage += "- Name: \(fileName)\n"
            bodyLogMessage += "- Type: \(fileType)\n"
            bodyLogMessage += "- Size: \(fileSize)\n"
            bodyLogMessage += "- Path: \(filePath)"
        } else if file.data != nil {
            let fileName = file.name
            let fileType = file.mimeType.rawValue
            let fileSize = file.size.formattedSize
            bodyLogMessage += "{ File From Memory }\n"
            bodyLogMessage += "- Name: \(fileName)\n"
            bodyLogMessage += "- Type: \(fileType)\n"
            bodyLogMessage += "- Size: \(fileSize)"
        }
        
        return bodyLogMessage
    }
    
    /// Makes cURL body option for outgoing request.
    ///
    /// - Parameters:
    ///   - file: `HTTPUploadRequestFile` file details to be printed in place of body.
    ///
    /// - Returns: `String` of outgoing request cURL command option.
    private func makeCURLBodyOption(for file: HTTPUploadRequestFile) -> String {
        var curlBodyOption = ""
        
        if let filePath = file.path {
            curlBodyOption += "--upload-file \(filePath)"
        }
        
        return curlBodyOption
    }
    
}
