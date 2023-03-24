//
//  File.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

struct File {
    let key: String
    let name: String
    let url: URL?
    let data: Data?
    let mimeType: String
    init(forKey key: String, withName name: String, withData data: Data, withMimeType mimeType: String) {
        self.key = key
        self.name = name
        self.url = nil
        self.data = data
        self.mimeType = mimeType
    }
    init(forKey key: String, withURL url: URL, withMimeType mimeType: String) {
        let name = url.lastPathComponent
        self.key = key
        self.name = name
        self.url = url
        self.data = nil
        self.mimeType = mimeType
    }
}
