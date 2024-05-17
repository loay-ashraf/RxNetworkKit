//
//  Set+SecKey.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/05/2024.
//

import Foundation

public extension Set where Element == SecKey {
    
    /// A set of all the certificate public keys that can be read from the main bundle
    /// `cer`, `der`, `crt` and `pem` file extensions are supported.
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
    
    /// Reads the public key of a single certificate from the main bundle.
    ///
    /// - Parameters:
    ///   - name: name of the certificate file.
    ///   - `extension`: extension of the certificate file.
    ///
    /// - Returns: a set containing a single certificate object read from the main bundle using the provided name and extension.
    static func singleFromBundle(_ name: String, _ `extension`: String) -> Set<SecKey> {
        Set([.fromBundle(name, `extension`)!])
    }
    
}
