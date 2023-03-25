//
//  FormUploadModel.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

// MARK: - FormUploadModel
struct FormUploadModel: Codable {
    let errors: [FormUploadError]?
    let files: [FormUploadFileModel]
}

// MARK: - FormUploadError
struct FormUploadError: Codable {
    let error: FormUploadErrorDetail
    let formDataFieldName: String
}

// MARK: - FormUploadErrorDetail
struct FormUploadErrorDetail: Codable {
    let code, message: String
}

// MARK: - FormUploadFileModel
struct FormUploadFileModel: Codable {
    let accountID, filePath: String
    let fileURL: String
    let formDataFieldName: String
    enum CodingKeys: String, CodingKey {
        case accountID = "accountId"
        case filePath
        case fileURL = "fileUrl"
        case formDataFieldName
    }
}
