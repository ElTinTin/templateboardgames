//
//  BoardgamesFeature.swift
//  templateboardgames
//
//  Created by Quentin Deschamps on 18/07/2023.
//

import Foundation
import Combine
import ComposableArchitecture

struct BoardgamesState: Equatable {
    var boardgames: [BoardgameModel] = []
    var favoriteBoardgames: [BoardgameModel] = []
    var selectedBoardgame: BoardgameModel?
}

enum BoardgamesAction: Equatable {
    case onAppear
    case dataLoaded(Result<[BoardgameModel], APIError>)
    case favoriteButtonTapped(BoardgameModel)
    case selectBoardgame(BoardgameModel)
}

struct BoardgamesEnvironment {
    var boardgamesRequest: (JSONDecoder) -> EffectPublisher<[BoardgameModel], APIError>
}

let boardgamesReducer = AnyReducer<
    BoardgamesState,
    BoardgamesAction,
    SystemEnvironment<BoardgamesEnvironment>> { state, action, environment in
        switch action {
        case .onAppear:
            return environment.boardgamesRequest(environment.decoder())
                .receive(on: environment.mainQueue())
                .catchToEffect()
                .map(BoardgamesAction.dataLoaded)
        case .dataLoaded(let result):
            switch result {
            case .success(let boardgames):
                state.boardgames = boardgames
            case .failure(let error):
                break
            }
            return .none
        case .favoriteButtonTapped(let boardgames):
            if state.favoriteBoardgames.contains(boardgames) {
                state.favoriteBoardgames.removeAll { $0 == boardgames }
            } else {
                state.favoriteBoardgames.append(boardgames)
            }
            return .none
        case .selectBoardgame(let boardgame):
            state.selectedBoardgame = boardgame
            return .none
        }
    }
