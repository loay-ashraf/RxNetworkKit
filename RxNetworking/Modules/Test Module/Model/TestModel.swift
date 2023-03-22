//
//  TestModel.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 20/03/2023.
//

import Foundation

struct TestModel: Decodable {
    let text: String
    let number: Int
}

struct TestUploadModel: Decodable {
    let accountId: String
    let filePath: String
    let fileURL: String
    enum CodingKeys: String, CodingKey {
        case accountId
        case filePath
        case fileURL = "fileUrl"
    }
}
