//
//  Model.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 20/03/2023.
//

import Foundation

struct Model: Decodable {
    let id: Int
    let avatarURL: URL
    let htmlURL: URL
    let login: String
    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case login
    }
}
