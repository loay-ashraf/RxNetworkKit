//
//  UploadEvent.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 22/03/2023.
//

import Foundation

public enum UploadEvent<T: Decodable> {
    case completed(model: T)
    case progress(progress: Progress)
}
