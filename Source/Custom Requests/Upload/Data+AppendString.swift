//
//  Data+AppendString.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

extension Data {
    /// Appends string to `Data` object.
    ///
    /// - Parameter string: `String` to be appended to `Data` object.
   mutating func append(_ string: String) {
      if let data = string.data(using: .utf8) {
         append(data)
      }
   }
}
