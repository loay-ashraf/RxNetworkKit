//
//  HTTPDownloadRequestEvent.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/03/2023.
//

import Foundation

/// An enumeration of the types of events received during a download operation.
public enum HTTPDownloadRequestEvent {
    /// The download request has completed with the file saved to the disk.
    case completed
    /// The download request has completed with the file data.
    case completedWithData(data: Data?)
    /// The download request has progressed.
    case progress(progress: Progress)
}
