//
//  HTTPDownloadRequestEvent.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/03/2023.
//

import Foundation

/// An enumeration of the types of events received during a download operation.
public enum HTTPDownloadRequestEvent {
    case completed
    case completedWithData(data: Data?)
    case progress(progress: Progress)
}
