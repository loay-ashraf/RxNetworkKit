//
//  MainApp.swift
//  SPMDummy
//
//  Created by Loay Ashraf on 10/01/2024.
//

#if os(watchOS)
import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
#endif
