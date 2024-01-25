//
//  MainView.swift
//  watchOS Example Watch App
//
//  Created by Loay Ashraf on 09/01/2024.
//

import SwiftUI
import RxNetworkKit
import CoreExample

struct MainView: View {
    @ObservedObject var users: RxBindingMediator<[Model]>
    private let viewModel: ViewModel
    
    /// Initializer
    init() {
        let requestInterceptor = RequestInterceptor()
        let session = Session(configuration: .default)
        let restClient = RESTClient(session: session, requestInterceptor: requestInterceptor)
        let httpClient = HTTPClient(session: session, requestInterceptor: requestInterceptor)
        viewModel = .init(restClient: restClient, httpClient: httpClient)
        users = .init(input: viewModel.users, output: [])
    }
    
    /// Body of the view
    var body: some View {
        ScrollView {
            LazyVStack(content: {
                ForEach(users.output, id: \.login) { user in
                    HStack(alignment: .center, spacing: 10.0) {
                        RemoteImage(downloadObesrvable: viewModel.downloadImage(DownloadRequestRouter.default(url: user.avatarURL)))
                        Text(user.login)
                        Spacer()
                    }
                    .padding(5)
                }
            })
            .onAppear {
                viewModel.viewState.accept(.loading(loadType: .initial))
            }
        }
    }
}
