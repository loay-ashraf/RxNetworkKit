//
//  EventMonitor.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 28/03/2023.
//

import Foundation

/// To monitor network events in a given session, all you have to do
/// is implement its delegate methods, easy and simple isn't it? 🤔.
typealias NetworkEventMonitor = URLSessionDelegate & URLSessionTaskDelegate & URLSessionDataDelegate & URLSessionStreamDelegate & URLSessionDownloadDelegate & URLSessionWebSocketDelegate
