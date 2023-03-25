//
//  UploadFile.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

struct UploadFile {
    let key: String
    let name: String
    let url: URL?
    let data: Data?
    let mimeType: HTTPMIMEType
    /// Creates `File` instance, use this initializer for relativley small files.
    ///
    /// - Parameters:
    ///   - key: file key or id.
    ///   - name: file name.
    ///   - data: `Data` object for file.
    init?(forKey key: String, withName name: String, withData data: Data) {
        self.key = key
        self.name = name
        self.url = nil
        self.data = data
        guard let mime = HTTPMIMEType(fileName: name) else { return nil }
        self.mimeType = mime
    }
    /// Creates `File` instance, use this initializer for relativley large files.
    ///
    /// - Parameters:
    ///   - key: file key or id.
    ///   - url: local `URL` for the file.
    init?(forKey key: String, withURL url: URL) {
        let name = url.lastPathComponent
        self.key = key
        self.name = name
        self.url = url
        self.data = nil
        guard let mime = HTTPMIMEType(fileName: name) else { return nil }
        self.mimeType = mime
    }
}
