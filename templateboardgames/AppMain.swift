//
//  templateboardgamesApp.swift
//  templateboardgames
//
//  Created by Quentin Deschamps on 18/07/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct AppMain: App {
    @StateObject private var configManager = ConfigManager()
    
    var body: some Scene {
        WindowGroup {
            RootView(
                store: Store(
                    initialState: RootState(),
                    reducer: rootReducer,
                    environment: .live(environment: RootEnvironment())))
            .environmentObject(configManager)
        }
    }
}
