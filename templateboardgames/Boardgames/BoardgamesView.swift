//
//  BoardgamesView.swift
//  templateboardgames
//
//  Created by Quentin Deschamps on 18/07/2023.
//

import SwiftUI
import Combine
import ComposableArchitecture

struct BoardgamesListView: View {
    @EnvironmentObject private var configManager: ConfigManager
    let store: Store<BoardgamesState, BoardgamesAction>
    
    @State private var searchText = ""
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Text(configManager.appName)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                SearchBar(text: $searchText)
                ScrollView {
                    LazyVStack {
                        ForEach(viewStore.boardgames.filter({ searchText.isEmpty ? true : $0.name.contains(searchText) })) { boardgame in
                            BoardgameView(store: store, boardgame: boardgame)
                                .padding()
                                .onTapGesture {
                                    viewStore.send(.selectBoardgame(boardgame))
                                }
                        }
                    }
                }
                .background(.white)
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}

struct FavoritesListView: View {
    @EnvironmentObject private var configManager: ConfigManager
    let store: Store<BoardgamesState, BoardgamesAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Text(configManager.appName)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                ScrollView {
                    LazyVStack {
                        ForEach(viewStore.favoriteBoardgames) { boardgame in
                            BoardgameView(store: store, boardgame: boardgame)
                                .padding()
                        }
                    }
                }
            }
        }
    }
}

struct BoardgameView: View {
    @EnvironmentObject private var configManager: ConfigManager
    let store: Store<BoardgamesState, BoardgamesAction>
    let boardgame: BoardgameModel
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                AsyncImage(url: URL(string: boardgame.image_url)) { image in
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                } placeholder: {
                }
                .frame(width: 150, height: 200)
                .background(configManager.primaryColorLight)
                .clipShape(CustomCardCutBackground())
                VStack(alignment: .leading) {
                    HStack {
                        Text(boardgame.name)
                            .font(.headline)
                        Spacer()
                        Button(
                            action: { viewStore.send(.favoriteButtonTapped(boardgame)) } ,
                            label: {
                                if viewStore.favoriteBoardgames.contains(boardgame) {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(configManager.primaryColorMedium)
                                } else {
                                    Image(systemName: "heart")
                                }
                            })
                    }
                    VStack(alignment: .center) {
                        FiveStarView(rating: Decimal(boardgame.average_user_rating ?? 0.0), color: configManager.primaryColorMedium, backgroundColor: .gray.opacity(0.2))
                            .frame(minWidth: 1, maxWidth: 100, minHeight: 20, maxHeight: 20)
                        HStack {
                            Image(systemName: "person.2")
                            if boardgame.min_players == boardgame.max_players {
                                Text("\(boardgame.min_players ?? 0)")
                            } else {
                                Text("\(boardgame.min_players ?? 0) - \(boardgame.max_players ?? 0)")
                            }
                        }
                        .padding(.top, 2)
                        HStack {
                            Image(systemName: "clock")
                            if boardgame.min_playtime == boardgame.max_playtime {
                                Text(boardgame.min_playtime == 0 ? "Inconnu" : "\(String(boardgame.min_playtime ?? 0))'")
                                    .opacity(0.5)
                            } else {
                                Text(boardgame.min_playtime == 0 ? "Inconnu" : "\(String(boardgame.min_playtime ?? 0))' - \(boardgame.max_playtime ?? 0)'")
                                    .opacity(0.5)
                            }
                        }
                        .padding(.top, 2)
                    }
                }
                .padding()
                Spacer()
            }
            
            .frame(maxWidth: .infinity, maxHeight: 200)
            .foregroundColor(Color.black)
            .background(.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(configManager.primaryColorLight, lineWidth: 4)
            )
        }
    }
}

struct RepositoryListView_Previews: PreviewProvider {
    static var previews: some View {
        BoardgamesListView(
            store: Store(
                initialState: BoardgamesState(),
                reducer: boardgamesReducer,
                environment: .dev(environment: BoardgamesEnvironment(boardgamesRequest: dummyBoardgameEffect))))
    }
}
