//
//  SecCertificate+PublicKey.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/05/2024.
//

import Foundation

public extension SecCertificate {
    
    /// Public key for this `SecCertificate` object.
    var publicKey: SecKey? {
        SecCertificateCopyKey(self)
    }
    
}
