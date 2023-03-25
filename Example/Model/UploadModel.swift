//
//  UploadModel.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

struct UploadModel: Decodable {
    let accountId: String
    let filePath: String
    let fileURL: String
    enum CodingKeys: String, CodingKey {
        case accountId
        case filePath
        case fileURL = "fileUrl"
    }
}
