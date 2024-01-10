//
//  URLSessionConfiguration+setUserAgentHTTPHeader.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 21/08/2023.
//

import Foundation

extension URLSessionConfiguration {
    /// Sets `User-Agent` header as an additional HTTP header.
    func setUserAgentHTTPHeader() {
        let mainBundle = Bundle.main
        let frameworkBundle = Bundle.init(for: HTTPClient.self)
        let mainBundleIndentifier = mainBundle.bundleIdentifier ?? "Unknown Client Identifier"
        let frameworkBundleVersion = frameworkBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let osName = ProcessInfo.processInfo.operatingSystemName
        let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
        setAdditionalHTTPHeader("User-Agent", value: "RxNetworkKit/\(frameworkBundleVersion) (\(osName) \(osVersion)-\(mainBundleIndentifier))")
    }
}
