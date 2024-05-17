//
//  TLSTrustEvaluator.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/05/2024.
//

import Foundation

/// The object responsible for evaluating TLS server trust for hosts using the provided policies.
final class TLSTrustEvaluator: NSObject {
    
    /// Set of hosts that did not pass the TLS server trust evaluation.
    fileprivate static var blockedHosts: Set<String> = []
    /// Configuration for TLS server trust evaluation.
    fileprivate let configuration: TLSTrustEvaluatorConfiguration
    
    /// Creates a `TLSTrustEvaluator` instance.
    ///
    /// - Parameter configuration: `TLSTrustEvaluatorConfiguration` object used to configure and create tthe `TLSTrustEvaluator` instance.
    init(configuration: TLSTrustEvaluatorConfiguration) {
        self.configuration = configuration
    }
    
    /// Returns the blocked hosts.
    ///
    /// - Returns: `Set<String>` hosts that did not pass the TLS server trust evaluation.
    static func getBlockedHosts() -> Set<String> {
        return blockedHosts
    }
    
    /// Adds a new blocked host.
    ///
    /// - Parameter host: `String` host that did not pass the TLS server trust evaluation.
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
