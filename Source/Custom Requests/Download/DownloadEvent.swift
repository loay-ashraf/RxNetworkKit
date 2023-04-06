//
//  DownloadEvent.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/03/2023.
//

import Foundation

public enum DownloadEvent {
    case completed
    case completedWithData(data: Data?)
    case progress(progress: Progress)
}
