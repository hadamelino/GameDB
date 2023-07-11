//
//  Game.swift
//  GameDB
//
//  Created by Hada Melino on 15/05/23.
//

import Foundation


struct GameResponse: Decodable {
    internal var data: [Game] = []
    
    private enum CodingKeys: String, CodingKey {
        case data = "results"
    }
}

internal struct Game: Decodable, Equatable {
    internal let id: Int
    internal let name: String
    internal var released: String? = ""
    internal var rating: Float?
    internal var backgroundImageURL: String? = ""
    
    private enum CodingKeys: String, CodingKey {
        case name, released, rating, id
        case backgroundImageURL = "background_image"
    }
    
    internal func ratingOneDecimal() -> Float {
        guard let rating = rating else { return 0 }
        return Float(round(rating * 10) / 10)
    }
    
}

internal struct Detail: Decodable, Equatable {
    internal let id: Int
    internal let name: String
    internal let released: String?
    internal var rating: Float? 
    internal let backgroundImageURL: String?
    internal let playtime: Int?
    internal let description: String?
    internal var isFavorite: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case playtime, description, name, released, rating, id
        case backgroundImageURL = "background_image"
    }
    
    init(id: Int = 0, name: String = "", released: String = "", rating: Float = 0, backgroundImageURL: String = "", playtime: Int = 0, description: String = "", isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.released = released
        self.rating = rating
        self.backgroundImageURL = backgroundImageURL
        self.playtime = playtime
        self.description = description
        self.isFavorite = isFavorite
    }
    
    internal func ratingOneDecimal() -> Float {
        guard let rating = rating else { return 0 }
        return Float(round(rating * 10) / 10)
    }
}


