//
//  Set+SecCertificate.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/05/2024.
//

import Foundation

public extension Set where Element == SecCertificate {
    
    /// A set of all the certificates that can be read from the main bundle
    /// `cer`, `der`, `crt` and `pem` file extensions are supported.
    static var `default`: Set<SecCertificate> {
        var certificates: Set<SecCertificate> = []
        
        var cerURLs = Bundle.main.urls(forResourcesWithExtension: "cer", subdirectory: nil) ?? []
        cerURLs.append(contentsOf: Bundle.main.urls(forResourcesWithExtension: "CER", subdirectory: nil) ?? [])
        
        var derURLs = Bundle.main.urls(forResourcesWithExtension: "der", subdirectory: nil) ?? []
        derURLs.append(contentsOf: Bundle.main.urls(forResourcesWithExtension: "DER", subdirectory: nil) ?? [])
        
        var crtURLs = Bundle.main.urls(forResourcesWithExtension: "crt", subdirectory: nil) ?? []
        crtURLs.append(contentsOf: Bundle.main.urls(forResourcesWithExtension: "CRT", subdirectory: nil) ?? [])
        
        var pemURLs = Bundle.main.urls(forResourcesWithExtension: "pem", subdirectory: nil) ?? []
        pemURLs.append(contentsOf: Bundle.main.urls(forResourcesWithExtension: "PEM", subdirectory: nil) ?? [])
        
        for cerURL in cerURLs {
            if let certificateData = try? Data(contentsOf: cerURL),
               let certificate = certificateData.certificate {
                certificates.insert(certificate)
            }
        }
        
        for derURL in derURLs {
            if let certificateData = try? Data(contentsOf: derURL),
               let certificate = certificateData.certificate {
                certificates.insert(certificate)
            }
        }
        
        for crtURL in crtURLs {
            if let certificateData = try? Data(contentsOf: crtURL),
               let certificate = certificateData.certificate {
                certificates.insert(certificate)
            }
        }
        
        for pemURL in pemURLs {
            if let certificateData = try? Data(contentsOf: pemURL),
               let certificate = certificateData.certificate {
                certificates.insert(certificate)
            }
        }
        
        return certificates
    }
    
    /// Reads a single certificate from the main bundle.
    ///
    /// - Parameters:
    ///   - name: name of the certificate file.
    ///   - `extension`: extension of the certificate file.
    ///
    /// - Returns: a set containing a single certificate object read from the main bundle using the provided name and extension.
    static func singleFromBundle(_ name: String, _ `extension`: String) -> Set<SecCertificate> {
        Set([.fromBundle(name, `extension`)!])
    }
    
}
