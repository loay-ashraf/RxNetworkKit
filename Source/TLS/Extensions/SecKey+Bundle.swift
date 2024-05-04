//
//  SecKey+Bundle.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/05/2024.
//

import Foundation

public extension SecKey {
    
    static func fromBundle(_ name: String, _ `extension`: String) -> SecKey? {
        guard let fileURL = Bundle.main.url(forResource: name, withExtension: `extension`),
              let certificateData = try? Data(contentsOf: fileURL),
              let certificate = certificateData.certificate,
              let publicKey = certificate.publicKey else {
            return nil
        }
        return publicKey
    }
    
}
