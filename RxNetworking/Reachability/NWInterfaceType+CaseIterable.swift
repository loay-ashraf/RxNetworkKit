//
//  NWInterfaceType+CaseIterable.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 28/03/2023.
//

import Foundation
import Network

// Implement `CaseIterable` protocol so that you can iterate over all cases.
extension NWInterface.InterfaceType: CaseIterable {
    /// Stores all cases of `InterfaceType` enum.
    public static var allCases: [NWInterface.InterfaceType] = [.wifi,
                                                               .cellular,
                                                               .wiredEthernet,
                                                               .loopback,
                                                               .other]
}
