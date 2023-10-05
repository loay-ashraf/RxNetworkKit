//
//  UploadEvent.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 22/03/2023.
//

import Foundation

/// An enumeration of the types of events received during an upload operation.
public enum UploadEvent<T: Decodable> {
    case completed(model: T)
    case progress(progress: Progress)
}
