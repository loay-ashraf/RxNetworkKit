//
//  URLSession+FormUpload.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

extension URLSession {
    func fileUploadTask(with request: URLRequest, from file: File, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let fileData = extractFileData(file)
        let request = adaptUploadRequest(originalRequest: request, withContentType: file.mimeType.rawValue, withBody: fileData)
        let task = dataTask(with: request, completionHandler: completionHandler)
        return task
    }
    func formDataUploadTask(with request: URLRequest, from formData: FormData, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let boundary = generateFormBoundary()
        let dataBody = createFormDataBody(formData: formData, boundary: boundary)
        let request = adaptUploadRequest(originalRequest: request, withContentType: "multipart/form-data; boundary=\(boundary)", withBody: dataBody)
        let task = dataTask(with: request, completionHandler: completionHandler)
        return task
    }
    private func adaptUploadRequest(originalRequest: URLRequest, withContentType contentType: String, withBody body: Data?) -> URLRequest {
        var request = originalRequest
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }
    private func extractFileData(_ file: File) -> Data? {
        var data: Data? = nil
        if let fileData = file.data {
            data = fileData
        } else if let fileURL = file.url,
                  let fileData = try? Data(contentsOf: fileURL) {
            data = fileData
        }
        return data
    }
    private func createFormDataBody(formData: FormData, boundary: String) -> Data {
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
    private func generateFormBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}
