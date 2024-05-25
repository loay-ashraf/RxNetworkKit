//
//  HTTPUploadRequestFormData.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

/// Holds details for a mulipart form upload request.
public struct HTTPUploadRequestFormData {
    
    /// parameters (text data fields) to be included in the form HTTP body.
    let parameters: [String: String]
    /// files to be included in the form HTTP body.
    let files: [HTTPUploadRequestFormFile]
    
    /// Creates `HTTPUploadRequestFormData` instance.
    ///
    /// - Parameters:
    ///   - parameters: `[String: String]` parameters (text data fields) to be included in the form HTTP body.
    ///   - files: `[HTTPUploadRequestFormFile]` files to be included in the form HTTP body.
    public init(parameters: [String: String], files: [HTTPUploadRequestFormFile]) {
        self.parameters = parameters
        self.files = files
    }
    
}
