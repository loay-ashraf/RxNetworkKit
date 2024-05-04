//
//  SecCertificate+Bundle.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/05/2024.
//

import Foundation

public extension SecCertificate {
    
    static func fromBundle(_ name: String, _ `extension`: String) -> SecCertificate? {
        guard let fileURL = Bundle.main.url(forResource: name, withExtension: `extension`),
              let certificateData = try? Data(contentsOf: fileURL),
              let certificate = certificateData.certificate else {
            return nil
        }
        return certificate
    }
    
}
