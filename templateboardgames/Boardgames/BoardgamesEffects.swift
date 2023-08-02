//
//  BoardgamesEffects.swift
//  templateboardgames
//
//  Created by Quentin Deschamps on 18/07/2023.
//

import Foundation
import ComposableArchitecture
import Combine

func fetchBoardgames(decoder: JSONDecoder) -> AnyPublisher<[BoardgameModel], Error> {
    guard let url = URL(string: "https://api.boardgameatlas.com/api/search?client_id=GBwguUuxRG&limit=30&skip=0") else {
        return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }
    
    let request = URLRequest(url: url)
    
    return request.publisher()
        .decode(type: BoardgamesResult.self, decoder: JSONDecoder())
        .map(\.games)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}

func boardgamesEffect(decoder: JSONDecoder) -> EffectPublisher<[BoardgameModel], APIError> {
    return fetchBoardgames(decoder: decoder)
        .mapError { _ in APIError.decodingError }
        .eraseToEffect()
}

func dummyBoardgameEffect(decoder: JSONDecoder) -> EffectPublisher<[BoardgameModel], APIError> {
    let dummyBoardgames = [
        BoardgameModel(id: "000", name: "Carcata", url: "", image_url: "", year_published: 2017, min_players: 2, max_players: 4, min_playtime: 30, max_playtime: 30, min_age: 7, description: "", rank: 1, price: "30", mechanics: nil, categories: nil, average_user_rating: 2.5),
        BoardgameModel(id: "001", name: "Skyjo", url: "", image_url: "", year_published: 2017, min_players: 2, max_players: 4, min_playtime: 30, max_playtime: 30, min_age: 7, description: "", rank: 1, price: "30", mechanics: nil, categories: nil, average_user_rating: 4.6),
        BoardgameModel(id: "002", name: "Codenames", url: "", image_url: "", year_published: 2017, min_players: 2, max_players: 4, min_playtime: 30, max_playtime: 30, min_age: 7, description: "", rank: 1, price: "30", mechanics: nil, categories: nil, average_user_rating: 2.0),
    ]
    return EffectPublisher(value: dummyBoardgames)
}
