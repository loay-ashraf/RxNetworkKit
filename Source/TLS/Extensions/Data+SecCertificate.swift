//
//  Data+SecCertificate.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/05/2024.
//

import Foundation

extension Data {
    
    var certificate: SecCertificate? {
        guard let base64String = String(data: self, encoding: .utf8)?.replacingOccurrences(of: "-----BEGIN CERTIFICATE-----", with: "").replacingOccurrences(of: "-----END CERTIFICATE-----", with: ""),
              let base64DecodedData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) else {
            return SecCertificateCreateWithData(nil, self as CFData)
        }
        return SecCertificateCreateWithData(nil, base64DecodedData as CFData)
    }
    
}
