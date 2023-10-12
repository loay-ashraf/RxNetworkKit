//
//  Model.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 20/03/2023.
//

import Foundation

public struct Model: Decodable {
    public let id: Int
    public let avatarURL: URL
    public let htmlURL: URL
    public let login: String
    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case login
    }
}
