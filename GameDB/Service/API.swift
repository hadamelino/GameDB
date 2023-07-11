//
//  APIService.swift
//  GameDB
//
//  Created by Hada Melino on 15/05/23.
//

import Foundation

internal enum API {
    
    internal enum Types {
        
        internal enum Endpoint {
            case gameList(page: String, pageSize: String)
            case searchGame(search: String)
            case gameDetail(gameID: String)
            
            internal var url: URL {
                var components = URLComponents()
                let keyQuery = URLQueryItem(name: "key", value: "1003908b71514ec7aaf1fbbfbbc26a47")
                components.scheme = "https"
                components.host = "api.rawg.io"
                components.path = "/api/games"
                components.queryItems = []
                components.queryItems?.append(keyQuery)
                switch self {
                case .gameList(let page, let pageSize):
                    let pageQuery = URLQueryItem(name: "page", value: page)
                    let pageSizeQuery = URLQueryItem(name: "page_size", value: pageSize)
                    components.queryItems?.append(pageQuery)
                    components.queryItems?.append(pageSizeQuery)
                case .searchGame(let search):
                    let searchQuery = URLQueryItem(name: "search", value: search)
                    components.queryItems?.append(searchQuery)
                case .gameDetail(let gameID):
                    components.path.append("/\(gameID)")
                }
                return components.url!
            }
        }
        
        internal enum Method: String {
            case GET
        }
        
        internal enum CustomError: String, Error {
            case failedToLoadGameList
            case failedToSearchGames
            case failedToLoadGameDetail
            case connectionOffline
        }
        
    }
    
}
