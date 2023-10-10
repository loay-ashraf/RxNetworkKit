//
//  HTTPRequestEventMonitor.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 28/03/2023.
//

import Foundation

// To monitor network events in a given session, all you have to do
// is implement its delegate methods, easy and simple isn't it? 🤔.
///  Session and Tasks delegate.
public typealias HTTPRequestEventMonitor = URLSessionDelegate & URLSessionTaskDelegate & URLSessionDataDelegate & URLSessionStreamDelegate & URLSessionDownloadDelegate & URLSessionWebSocketDelegate
