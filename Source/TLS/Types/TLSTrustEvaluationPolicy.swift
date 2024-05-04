//
//  TLSTrustEvaluationPolicy.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/05/2024.
//

import Foundation

public enum TLSTrustEvaluationPolicy {
    case certificates(_ certificates: Set<SecCertificate> = .default)
    case publicKeys(_ publicKeys: Set<SecKey> = .default)
    case mixed(_ certificates: Set<SecCertificate> = .default, _ publicKeys: Set<SecKey> = .default)
}
