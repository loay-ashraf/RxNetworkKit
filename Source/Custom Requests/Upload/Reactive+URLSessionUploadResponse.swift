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
    /// Creates a tuple that includes progress `PublishSubject` and response and data `Single`.
    /// This method is inspired by RxCocoa's `response` method.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create upload task and its observables.
    ///   - file: `UploadFile` object to be uploaded.
    ///
    /// - Returns: a tuple of progress `PublishSubject` and response and data `Single`.
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
    /// Creates a tuple that includes progress `PublishSubject` and response and data `Single`.
    /// This method is inspired by RxCocoa's `response` method.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create upload task and its observables.
    ///   - formData: `UploadFormData` object that includes parameters and files to be uploaded.
    ///
    /// - Returns: a tuple of progress `PublishSubject` and response and data `Single`.
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
