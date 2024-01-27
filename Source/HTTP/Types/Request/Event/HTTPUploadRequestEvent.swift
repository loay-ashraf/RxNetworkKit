//
//  HTTPUploadRequestEvent.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 22/03/2023.
//

import Foundation

/// An enumeration of the types of events received during an upload operation.
public enum HTTPUploadRequestEvent<T: Decodable> {
    /// The upload request has completed with a response body.
    case completed(model: T)
    /// The upload request has progressed.
    case progress(progress: Progress)
}
