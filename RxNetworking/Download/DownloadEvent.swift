//
//  DownloadEvent.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 25/03/2023.
//

import Foundation

enum DownloadEvent {
    case completed
    case completedWithData(data: Data?)
    case progress(progress: Progress)
}
