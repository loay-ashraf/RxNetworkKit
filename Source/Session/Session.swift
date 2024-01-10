//
//  Session.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/11/2023.
//

import Foundation

/// Wrapper object for `URLSession` and `HTTPRequestEventMonitor` that can be shared between multiple clients.
public class Session {
    
    /// Principal `URLSession`object used to create request tasks.
    let urlSession: URLSession
    /// Principal `HTTPRequestEventMonitor` object used to monitor request tasks.
    let eventMonitor: HTTPRequestEventMonitor
    /// `OperationQueue` object used by event monitor.
    private let eventMonitorQueue: OperationQueue
    
    /// Creates a `Session` instance.
    ///
    /// - Parameters:
    ///   - configuration: `URLSessionConfiguration` object used to create `URLSession` instance.
    ///   - eventMonitor: `HTTPRequestEventMonitor` object for monitoring events for session.
    public init(configuration: URLSessionConfiguration, eventMonitor: HTTPRequestEventMonitor) {
        // Apply User-Agent header as a part of HTTP aditional headers.
        configuration.setUserAgentHTTPHeader()
        // Initialize session's properties.
        self.eventMonitor = eventMonitor
        self.eventMonitorQueue = .init()
        eventMonitorQueue.name = "RxNetworkKit/Session(\(UUID().uuidString))/Event Monitor Queue"
        eventMonitorQueue.qualityOfService = .utility
        eventMonitorQueue.maxConcurrentOperationCount = 20
        self.urlSession = .init(configuration: configuration,
                                delegate: eventMonitor,
                                delegateQueue: eventMonitorQueue)
        URLSession.rx.shouldLogRequest = { _ in false }
    }
    
}
