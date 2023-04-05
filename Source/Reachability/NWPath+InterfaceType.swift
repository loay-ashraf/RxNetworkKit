//
//  NWPath+InterfaceType.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 28/03/2023.
//

import Foundation
import Network

extension NWPath {
    /// Gets interface type used by the current `NWPath` instance.
    var interfaceType: NWInterface.InterfaceType {
        // We iterate over all interface types to check for type used by path.
        for type in NWInterface.InterfaceType.allCases {
            if usesInterfaceType(type) {
                return type
            }
        }
        // Otherwise return `other` interface type.
        // This line should never be reached.
        return .other
    }
}
