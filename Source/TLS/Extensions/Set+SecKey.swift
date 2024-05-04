//
//  Set+SecKey.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/05/2024.
//

import Foundation

public extension Set where Element == SecKey {
    
    static var `default`: Set<SecKey> {
        var publicKeys: Set<SecKey> = []
        
        let certificates: Set<SecCertificate> = .default
        
        for certificate in certificates {
            if let publicKey = SecCertificateCopyKey(certificate) {
                publicKeys.insert(publicKey)
            }
        }
        
        return publicKeys
    }
    
    static func singleFromBundle(_ name: String, _ `extension`: String) -> Set<SecKey> {
        Set([.fromBundle(name, `extension`)!])
    }
    
}
