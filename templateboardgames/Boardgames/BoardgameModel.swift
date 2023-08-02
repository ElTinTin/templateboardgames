//
//  BoardgamesModel.swift
//  templateboardgames
//
//  Created by Quentin Deschamps on 18/07/2023.
//

import Foundation

struct BoardgamesResult: Codable, Equatable {
    let games: [BoardgameModel]
}

struct BoardgameModel: Codable, Equatable, Identifiable {    
    let id: String
    let name: String
    let url: String
    let image_url: String
    let year_published: Int?
    let min_players: Int?
    let max_players: Int?
    let min_playtime: Int?
    let max_playtime: Int?
    let min_age: Int?
    let description: String
    let rank: Int
    let price: String
    let mechanics: [Items]?
    let categories: [Items]?
    let average_user_rating: Double?
    
    struct Items: Codable, Equatable {
        let id: String
    }
}
