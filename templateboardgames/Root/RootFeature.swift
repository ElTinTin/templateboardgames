//
//  RootFeature.swift
//  templateboardgames
//
//  Created by Quentin Deschamps on 18/07/2023.
//

import Foundation
import ComposableArchitecture

struct RootState {
  var boardgamesState = BoardgamesState()
}

enum RootAction {
  case boardgamesAction(BoardgamesAction)
}

struct RootEnvironment {
    
}

// swiftlint:disable trailing_closure
let rootReducer = AnyReducer<
  RootState,
  RootAction,
  SystemEnvironment<RootEnvironment>
>.combine(
  boardgamesReducer.pullback(
    state: \.boardgamesState,
    action: /RootAction.boardgamesAction,
    environment: { _ in .live(environment: BoardgamesEnvironment(boardgamesRequest: boardgamesEffect))}))
// swiftlint:enable trailing_closure

