//
//  SecKey+ExternalRepresentation.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/05/2024.
//

import Foundation

public extension SecKey {
    
    var externalRepresentation: CFData? {
        SecKeyCopyExternalRepresentation(self, nil)
    }
    
}
