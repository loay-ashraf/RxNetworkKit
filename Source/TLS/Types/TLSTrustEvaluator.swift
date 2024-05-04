//
//  TLSTrustEvaluator.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/05/2024.
//

import Foundation

final class TLSTrustEvaluator: NSObject {
    
    fileprivate static var blockedHosts: Set<String> = []
    fileprivate let configuration: TLSTrustEvaluatorConfiguration
    
    init(configuration: TLSTrustEvaluatorConfiguration) {
        self.configuration = configuration
    }
    
    static func getBlockedHosts() -> Set<String> {
        return blockedHosts
    }
    
    fileprivate static func insertBlockedHost(host: String) {
        blockedHosts.insert(host)
    }
    
}

extension TLSTrustEvaluator: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard !configuration.evaluationPolicies.isEmpty else {
            if configuration.evaluateAllHosts {
                completionHandler(.performDefaultHandling, nil)
            } else {
                TLSTrustEvaluator.insertBlockedHost(host: challenge.protectionSpace.host)
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
            return
        }
        
        guard let trust = challenge.protectionSpace.serverTrust else {
            TLSTrustEvaluator.insertBlockedHost(host: challenge.protectionSpace.host)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        if let evaluation = configuration.evaluationPolicies[challenge.protectionSpace.host] {
            
            switch evaluation {
                
            case .certificates(let certificates):
                
                guard evaluateCertificate(trust: trust, pinnedCertificates: certificates) else {
                    TLSTrustEvaluator.insertBlockedHost(host: challenge.protectionSpace.host)
                    completionHandler(.cancelAuthenticationChallenge, nil)
                    return
                }
                
            case .publicKeys(let publicKeys):
                
                guard evaluatePublicKey(trust: trust, pinnedPublicKeys: publicKeys) else {
                    TLSTrustEvaluator.insertBlockedHost(host: challenge.protectionSpace.host)
                    completionHandler(.cancelAuthenticationChallenge, nil)
                    return
                }
                
            case .mixed(let certificates, let publicKeys):
                
                if !evaluateCertificate(trust: trust, pinnedCertificates: certificates) {
                    guard evaluatePublicKey(trust: trust, pinnedPublicKeys: publicKeys) else {
                        TLSTrustEvaluator.insertBlockedHost(host: challenge.protectionSpace.host)
                        completionHandler(.cancelAuthenticationChallenge, nil)
                        return
                    }
                }
                
            }
            
            completionHandler(.useCredential, .init(trust: trust))
            
        } else {
            
            if configuration.evaluateAllHosts {
                completionHandler(.performDefaultHandling, nil)
            } else {
                TLSTrustEvaluator.insertBlockedHost(host: challenge.protectionSpace.host)
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
            
        }
        
    }
    
    private func evaluateCertificate(trust: SecTrust, pinnedCertificates: Set<SecCertificate>) -> Bool {
        SecTrustSetAnchorCertificates(trust, Array(pinnedCertificates) as CFArray)
        return SecTrustEvaluateWithError(trust, nil)
    }
    
    private func evaluatePublicKey(trust: SecTrust, pinnedPublicKeys: Set<SecKey>) -> Bool {
        if SecTrustGetCertificateCount(trust) > 0,
           let certificate = SecTrustGetCertificateAtIndex(trust, 0),
           let publicKey = certificate.publicKey,
           let publicKeyData = publicKey.externalRepresentation {
            let pinnedPublicKeysData = pinnedPublicKeys.compactMap({ $0.externalRepresentation })
            return pinnedPublicKeysData.contains(publicKeyData)
        }
        return false
    }
    
}
