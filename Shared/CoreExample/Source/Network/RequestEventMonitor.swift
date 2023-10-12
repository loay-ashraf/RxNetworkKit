//
//  RequestEventMonitor.swift
//  CoreExample
//
//  Created by Loay Ashraf on 12/10/2023.
//

public class RequestEventMonitor: NSObject, HTTPRequestEventMonitor {
    public override init() { }
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        debugPrint("")
    }
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        debugPrint(session)
    }
    public func urlSession(_ session: URLSession, didCreateTask task: URLSessionTask) {
        debugPrint("Task created!")
    }
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error else { return }
        debugPrint("Task did finish with error: \(error.localizedDescription)!")
    }
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) { }
}
