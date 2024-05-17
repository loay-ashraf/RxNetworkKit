//
//  TLSTrustEvaluationPolicy.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/05/2024.
//

import Foundation

/// Policy for TLS server trust evaluation.
public enum TLSTrustEvaluationPolicy {
    /// Use the given certificates to evaluate the TLS server trust.
    case certificates(_ certificates: Set<SecCertificate> = .default)
    /// Use the given public keys to evaluate the TLS server trust.
    case publicKeys(_ publicKeys: Set<SecKey> = .default)
    /// Use the given certificates or the public keys to evaluate the TLS server trust.
    case mixed(_ certificates: Set<SecCertificate> = .default, _ publicKeys: Set<SecKey> = .default)
}
