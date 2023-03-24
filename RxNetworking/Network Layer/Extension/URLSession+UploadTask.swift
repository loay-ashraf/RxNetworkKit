//
//  URLSession+FormUpload.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

extension URLSession {
    func fileUploadTask(with request: URLRequest, from file: File, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        var request = request
        var data: Data? = nil
        if let fileData = file.data {
            data = fileData
        } else if let fileURL = file.url,
                  let fileData = try? Data(contentsOf: fileURL) {
            data = fileData
        }
        request.setValue(file.mime.rawValue, forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        let task = dataTask(with: request, completionHandler: completionHandler)
        return task
    }
    func formDataUploadTask(with request: URLRequest, from formData: FormData, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        var request = request
        let boundary = generateFormBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let dataBody = createFormDataBody(formData: formData, boundary: boundary)
        request.httpBody = dataBody
        let task = dataTask(with: request, completionHandler: completionHandler)
        return task
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
            var data: Data = .init()
            if let fileData = file.data {
                data = fileData
            } else if let fileURL = file.url,
                      let fileData = try? Data(contentsOf: fileURL) {
                data = fileData
            } else {
                continue
            }
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(file.key)\"; filename=\"\(file.name)\"\(lineBreak)")
            body.append("Content-Type: \(file.mime.rawValue + lineBreak + lineBreak)")
            body.append(data)
            body.append(lineBreak)
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    private func generateFormBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}
