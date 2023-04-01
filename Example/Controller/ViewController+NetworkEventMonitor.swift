//
//  ViewController+NetworkEventMonitor.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 01/04/2023.
//

import Foundation

extension ViewController: NetworkEventMonitor {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        debugPrint("")
    }
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        debugPrint(session)
    }
    func urlSession(_ session: URLSession, didCreateTask task: URLSessionTask) {
        debugPrint("Task created!")
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error else { return }
        debugPrint("Task did finish with error: \(error.localizedDescription)!")
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) { }
}
