//
//  ProcessInfo+operatingSystemName.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 21/08/2023.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

extension ProcessInfo {
    /// Name of current operating system (iOS, iPadOS, watchOS, etc.)
    var operatingSystemName: String {
        var osName: String = ""
#if os(iOS)
#if targetEnvironment(macCatalyst)
        osName = "macOS - Catalyst"
#else
        if UIDevice.current.userInterfaceIdiom == .pad {
            osName = "iPadOS"
        } else {
            osName = "iOS"
        }
#endif
#elseif os(macOS)
        osName = "macOS"
#elseif os(watchOS)
        osName = "watchOS"
#elseif os(tvOS)
        osName = "tvOS"
#elseif os(visionOS)
        osName = "visionOS"
#endif
        return osName
    }
}
