//
//  RootView.swift
//  templateboardgames
//
//  Created by Quentin Deschamps on 18/07/2023.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: Store<RootState, RootAction>
    @EnvironmentObject private var configManager: ConfigManager
    
    
    var body: some View {
        WithViewStore(self.store.stateless) { _ in
            TabView {
                Group {
                    BoardgamesListView(
                        store: store.scope(
                            state: \.boardgamesState,
                            action: RootAction.boardgamesAction))
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Boardgames")
                    }
                    
                    if configManager.favoriteFeature {
                        FavoritesListView(
                            store: store.scope(
                                state: \.boardgamesState,
                                action: RootAction.boardgamesAction))
                        .tabItem {
                            Image(systemName: "heart.fill")
                            Text("Favorites")
                        }
                    }
                }
                .toolbarBackground(.visible, for: .tabBar)
            }
            .accentColor(configManager.primaryColorMedium)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let rootView = RootView(
            store: Store(
                initialState: RootState(),
                reducer: rootReducer,
                environment: .dev(environment: RootEnvironment())))
        return rootView
    }
}

