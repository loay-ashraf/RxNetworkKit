//
//  HTTPUploadRequestFormFile.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 21/05/2024.
//

import Foundation

/// Holds file details for multipart upload request.
public struct HTTPUploadRequestFormFile {
    
    /// key used for file record.
    let key: String
    /// name of the file.
    let name: String
    /// data of the file.
    let data: Data?
    /// local url of the file.
    let url: URL?
    /// MIME type of the file.
    let mimeType: HTTPMIMEType
    /// size of the file.
    let size: Int64
    
    /// Creates `File` instance, use this initializer for relativley small files (< 20MB).
    ///
    /// - Parameters:
    ///   - key: file key or id.
    ///   - name: file name.
    ///   - extension: file extension.
    ///   - data: `Data` object for file.
    public init?(forKey key: String, withName name: String, withExtension `extension`: String,  withData data: Data) {
        self.key = key
        self.name = name
        self.data = data
        self.url = nil
        guard let mime = HTTPMIMEType(fileExtension: `extension`) else { return nil }
        self.mimeType = mime
        self.size = Int64(data.count)
#if DEBUG
        if size > 20_971_520 {
            print("* * * * * * * * * * MEMORY WARNING * * * * * * * * * *\n")
            print("Holding a large file for upload in the device memory (> 20MB)\nPerformance may be reduced if the available memory is low.")
            print("\n* * * * * * * * * * * * * END * * * * * * * * * * * * *\n")
        }
#endif
    }
    
    /// Creates `File` instance, use this initializer for relativley large files (> 20MB).
    ///
    /// - Parameters:
    ///   - key: file key or id.
    ///   - url: local `URL` for the file.
    public init?(forKey key: String, withURL url: URL) {
        let fileName = url.lastPathComponent
        let (name, `extension`) = fileName.splitNameAndExtension()
        self.key = key
        self.name = name
        self.data = nil
        self.url = url
        guard let mime = HTTPMIMEType(fileExtension: `extension`) else { return nil }
        self.mimeType = mime
        guard let size = FileManager.default.sizeOfFile(atURL: url) else { return nil }
        self.size = size
    }
    
}
