//
//  HTTPUploadRequestFile.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

/// Holds file details for upload request.
public struct HTTPUploadRequestFile {
    
    /// name of the file.
    let name: String
    /// absolute path of the file.
    let path: String?
    /// data of the file.
    let data: Data?
    /// input stream of the file.
    let inputStream: InputStream?
    /// MIME type of the file.
    let mimeType: HTTPMIMEType
    /// size of the file.
    let size: Int64
    
    /// Creates `File` instance, use this initializer for relativley small files (< 20MB).
    ///
    /// - Parameters:
    ///   - name: file name.
    ///   - extension: file extension.
    ///   - data: `Data` object for file.
    public init?(withName name: String, withExtension `extension`: String, withData data: Data) {
        self.name = name
        self.path = nil
        self.data = data
        self.inputStream = nil
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
    ///   - url: local `URL` for the file.
    public init?(withURL url: URL) {
        let fileName = url.lastPathComponent
        let (name, `extension`) = fileName.splitNameAndExtension()
        self.name = name
        if #available(iOS 16, macOS 13, tvOS 16, watchOS 9, *) {
            self.path = url.path()
        } else {
            self.path = url.path
        }
        self.data = nil
        self.inputStream = .init(url: url)
        guard let mime = HTTPMIMEType(fileExtension: `extension`) else { return nil }
        self.mimeType = mime
        guard let size = FileManager.default.sizeOfFile(atURL: url) else { return nil }
        self.size = size
    }
    
}
