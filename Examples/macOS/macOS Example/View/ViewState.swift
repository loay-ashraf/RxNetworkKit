//
//  ViewState.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/04/2023.
//

enum ViewState: Equatable {
    case idle
    case loading(loadType: ViewLoadType)
    case error
}
