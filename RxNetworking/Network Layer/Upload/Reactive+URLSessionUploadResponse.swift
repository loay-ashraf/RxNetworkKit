//
//  Reactive+URLSessionResponse.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 22/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: URLSession {
    func uploadResponse(request: URLRequest, file: UploadFile) -> (PublishSubject<Progress>, Single<(response: HTTPURLResponse, data: Data)>) {
        // we must keep refernce to task progress observation object
        var taskProgressObservation: NSKeyValueObservation?
        let taskProgressSubject = PublishSubject<Progress>()
        let taskResponseSingle = Single<(response: HTTPURLResponse, data: Data)>.create { single in
            // smart compiler should be able to optimize this out
            let d: Date?
            if URLSession.rx.shouldLogRequest(request) {
                d = Date()
            } else {
                d = nil
            }
            let task = self.base.fileUploadTask(with: request, from: file) { data, response, error in
                if URLSession.rx.shouldLogRequest(request) {
                    let interval = Date().timeIntervalSince(d ?? Date())
                    print(convertURLRequestToCurlCommand(request))
#if os(Linux)
                    print(convertResponseToString(response, error.flatMap { $0 as NSError }, interval))
#else
                    print(convertResponseToString(response, error.map { $0 as NSError }, interval))
#endif
                }
                guard let response = response, let data = data else {
                    single(.failure(error ?? RxCocoaURLError.unknown))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    single(.failure(RxCocoaURLError.nonHTTPResponse(response: response)))
                    return
                }
                single(.success((httpResponse, data)))
            }
            taskProgressObservation = task.progress.observe(\.fractionCompleted) { progress, _ in
                taskProgressSubject.onNext(progress)
                if progress.fractionCompleted == 1.00 {
                    taskProgressSubject.onCompleted()
                }
            }
            task.resume()
            return Disposables.create(with: task.cancel)
        }
        return (taskProgressSubject, taskResponseSingle)
    }
    func uploadResponse(request: URLRequest, formData: UploadFormData) -> (PublishSubject<Progress>, Single<(response: HTTPURLResponse, data: Data)>) {
        // we must keep refernce to task progress observation object
        var taskProgressObservation: NSKeyValueObservation?
        let taskProgressSubject = PublishSubject<Progress>()
        let taskResponseSingle = Single<(response: HTTPURLResponse, data: Data)>.create { single in
            // smart compiler should be able to optimize this out
            let d: Date?
            if URLSession.rx.shouldLogRequest(request) {
                d = Date()
            } else {
                d = nil
            }
            let task = self.base.formDataUploadTask(with: request, from: formData) { data, response, error in
                if URLSession.rx.shouldLogRequest(request) {
                    let interval = Date().timeIntervalSince(d ?? Date())
                    print(convertURLRequestToCurlCommand(request))
#if os(Linux)
                    print(convertResponseToString(response, error.flatMap { $0 as NSError }, interval))
#else
                    print(convertResponseToString(response, error.map { $0 as NSError }, interval))
#endif
                }
                guard let response = response, let data = data else {
                    single(.failure(error ?? RxCocoaURLError.unknown))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    single(.failure(RxCocoaURLError.nonHTTPResponse(response: response)))
                    return
                }
                single(.success((httpResponse, data)))
            }
            taskProgressObservation = task.progress.observe(\.fractionCompleted) { progress, _ in
                taskProgressSubject.onNext(progress)
                if progress.fractionCompleted == 1.00 {
                    taskProgressSubject.onCompleted()
                }
            }
            task.resume()
            return Disposables.create(with: task.cancel)
        }
        return (taskProgressSubject, taskResponseSingle)
    }
}
extension Reactive where Base: URLSession {
    fileprivate func escapeTerminalString(_ value: String) -> String {
        return value.replacingOccurrences(of: "\"", with: "\\\"", options:[], range: nil)
    }
    fileprivate func convertURLRequestToCurlCommand(_ request: URLRequest) -> String {
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
    fileprivate func convertResponseToString(_ response: URLResponse?, _ error: NSError?, _ interval: TimeInterval) -> String {
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
