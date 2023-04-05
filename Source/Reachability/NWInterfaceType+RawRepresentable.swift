//
//  NWInterfaceType+RawRepresentable.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 29/03/2023.
//

import Foundation
import Network

extension NWInterface.InterfaceType: RawRepresentable {
    /// Creates `NWInterface.InterfaceType` instance using given raw value `String`.
    ///
    /// - Parameter rawValue: `String` raw value used to create instance.
    public init?(rawValue: String) {
        switch rawValue {
        case "Other":
            self = .other
        case "Wifi":
            self = .wifi
        case "Cellular":
            self = .cellular
        case "Ethernet":
            self = .wiredEthernet
        case "Loopback":
            self = .loopback
        default:
            return nil
        }
    }
    /// `String` raw value of current instance.
    public var rawValue: String {
        switch self {
        case .other: return "Other"
        case .wifi: return "Wifi"
        case .cellular: return "Cellular"
        case .wiredEthernet: return "Ethernet"
        case .loopback: return "Loopback"
        @unknown default: return "Unsupported"
        }
    }
}
