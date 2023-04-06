//
//  NetworkReachabilityStatus.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 29/03/2023.
//

import Foundation
import Network

public enum NetworkReachabilityStatus: Equatable {
    case reachable(interfaceType: NetworkInterfaceType)
    case unReachable
    /// Creates `NetworkReachabilityStatus` instance.
    ///
    /// - Parameter path: `NWPath` which holds status and interface type.
    init(path: NWPath) {
        let status = path.status
        switch status {
        case .satisfied:
            let interfaceType = path.interfaceType
            self = .reachable(interfaceType: interfaceType)
        default:
            self = .unReachable
        }
    }
}
