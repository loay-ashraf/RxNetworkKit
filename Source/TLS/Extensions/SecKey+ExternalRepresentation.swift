//
//  SecKey+ExternalRepresentation.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/05/2024.
//

import Foundation

public extension SecKey {
    
    /// External representation for this `SecKey` object.
    var externalRepresentation: CFData? {
        SecKeyCopyExternalRepresentation(self, nil)
    }
    
}
