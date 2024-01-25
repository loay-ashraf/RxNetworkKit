//
//  Data+JSON.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/01/2024.
//

import Foundation

extension Data {
    
    /// JSON formatted string for this `Data` object.
    var json: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .withoutEscapingSlashes]) else { return nil }
        let prettyPrintedString = String(decoding: data, as: UTF8.self)
        return prettyPrintedString
    }
    
}
