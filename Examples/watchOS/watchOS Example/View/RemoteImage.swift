//
//  RemoteImage.swift
//  watchOS Example Watch App
//
//  Created by Loay Ashraf on 10/01/2024.
//

import SwiftUI
import RxSwift
import RxNetworkKit

struct RemoteImage: View {
    @ObservedObject private var image: RxImageDownloadBindingMediator
    
    /// Initializer
    init(downloadObesrvable: Observable<HTTPDownloadRequestEvent>) {
        image = .init(input: downloadObesrvable, output: .init())
    }
    
    /// Body of the view
    var body: some View {
        Image(uiImage: image.output)
            .resizable()
            .frame(width: 50, height: 50)
            .scaledToFit()
            .clipShape(Circle())
    }
}
