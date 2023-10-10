//
//  URLSession+UploadTask.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

extension URLSession {
    /// Creates a data task with HTTP body of given file data.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create data task.
    ///   - file: `File` object that includes name, data, url and HTTP MIME type.
    ///   - completionHandler: completion handler to be called on task completion.
    ///
    /// - Returns: upload`URLSessionDataTask` created using given request and file.
    func fileUploadTask(with request: URLRequest, from file: HTTPUploadRequestFile, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let fileData = extractFileData(file)
        let request = adaptUploadRequest(originalRequest: request, withContentType: file.mimeType.rawValue, withBody: fileData)
        let task = dataTask(with: request, completionHandler: completionHandler)
        return task
    }
    /// Creates a data task with HTTP body of given form data.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create data task.
    ///   - formData: `FormData` object that includes text data fields and files to be uploaded.
    ///   - completionHandler: completion handler to be called on task completion.
    ///
    /// - Returns: upload`URLSessionDataTask` created using given request and form data.
    func formDataUploadTask(with request: URLRequest, from formData: HTTPUploadRequestFormData, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let boundary = generateFormBoundary()
        let dataBody = createFormDataBody(formData: formData, boundary: boundary)
        let request = adaptUploadRequest(originalRequest: request, withContentType: "multipart/form-data; boundary=\(boundary)", withBody: dataBody)
        let task = dataTask(with: request, completionHandler: completionHandler)
        return task
    }
}

extension URLSession {
    /// Adapts upload url request by applying 'Content-Type' HTTP header and HTTP body.
    ///
    /// - Parameters:
    ///   - originalRequest: original `URLRequest`.
    ///   - contentType: value for 'Content-Type' HTTP header.
    ///   - body: value for HTTP body.
    ///
    /// - Returns: Adapted `URLRequest`.
    fileprivate func adaptUploadRequest(originalRequest: URLRequest, withContentType contentType: String, withBody body: Data?) -> URLRequest {
        var request = originalRequest
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }
    
    /// Exxtracts data from file object.
    ///
    /// - Parameter file: `File` object that includes data or url.
    ///
    /// - Returns: `Data` object representing the file.
    fileprivate func extractFileData(_ file: HTTPUploadRequestFile) -> Data? {
        var data: Data? = nil
        if let fileData = file.data {
            data = fileData
        } else if let fileURL = file.url,
                  let fileData = try? Data(contentsOf: fileURL) {
            data = fileData
        }
        return data
    }
    /// Creates HTTP body data using given form data and boundary.
    ///
    /// - Parameters:
    ///   - formData: `FormData` object used to create HTTP body.
    ///   - boundary: `String` boundary used to mark start of body section.
    ///
    /// - Returns: `Data` object representing HTTP body.
    fileprivate func createFormDataBody(formData: HTTPUploadRequestFormData, boundary: String) -> Data {
        let files = formData.files
        let lineBreak = "\r\n"
        var body = Data()
        let parameters = formData.parameters
        for (key, value) in parameters {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value + lineBreak)")
        }
        for file in files {
            guard let fileData = extractFileData(file) else { continue }
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(file.key)\"; filename=\"\(file.name)\"\(lineBreak)")
            body.append("Content-Type: \(file.mimeType.rawValue + lineBreak + lineBreak)")
            body.append(fileData)
            body.append(lineBreak)
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    /// Generate boundary string.
    ///
    /// - Returns: `String` boundary.
    fileprivate func generateFormBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}
