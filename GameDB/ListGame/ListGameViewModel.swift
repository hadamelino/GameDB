//
//  ListGameViewModel.swift
//  GameDB
//
//  Created by Hada Melino on 15/05/23.
//

import Foundation

protocol ViewModelOutput: AnyObject {
    func updateView(with state: ViewState)
}

enum ViewState {
    case idle, loading, success, error(Error)
}

enum UserState{
    case normal, searching
}

final class ListGameViewModel {
    
    weak var delegate: ViewModelOutput?
    private let client: ClientServiceProtocol
    private var viewState: ViewState {
        didSet {
            self.delegate?.updateView(with: viewState)
        }
    }
    internal var userState: UserState {
        didSet {
            self.delegate?.updateView(with: viewState)
        }
    }
    
    private var page = 1
    private let pageSize = 10
    internal var games: [Game] {
        didSet {
            if games.isEmpty { return }
            for (index, game) in games.enumerated() {
                games[index].rating = game.ratingOneDecimal()
            }
        }
    }
    internal var searchedGames: [Game] {
        didSet {
            if searchedGames.isEmpty { return }
            for (index, searchedGame) in searchedGames.enumerated() {
                searchedGames[index].rating = searchedGame.ratingOneDecimal()
            }
        }
    }
    internal var numberOfGames: Int {
        games.count
    }
    internal var numberOfSearchedGames: Int {
        searchedGames.count
    }
    
    
    init(client: ClientServiceProtocol = API.Client.shared) {
        self.viewState = .idle
        self.userState = .normal
        self.client = client
        self.games = []
        self.searchedGames = []
    }
    
}

extension ListGameViewModel {

    internal func getInfo(for indexPath: IndexPath) -> (name: String,
                                                        released: String,
                                                        rating: Float,
                                                        backgroundImageURL: String)
    {
        let emptyGame = (
            name: "",
            released: "",
            rating: 0 as Float,
            backgroundImageURL: ""
        )
        
        switch userState {
        case .normal:
            guard games.count > indexPath.row else { return emptyGame }
            let game = games[indexPath.row]
            return (game.name,
                    game.released ?? "",
                    game.rating ?? 0,
                    game.backgroundImageURL ?? "")
        case .searching:
            guard searchedGames.count > indexPath.row else { return emptyGame }
            let searchedGame = searchedGames[indexPath.row]
            return (searchedGame.name,
                    searchedGame.released ?? "",
                    searchedGame.rating ?? 0,
                    searchedGame.backgroundImageURL ?? "")
        }
    }
    
    internal func getID(for indexPath: IndexPath) -> String {
        var dataSource = [Game]()
        switch userState {
        case .normal:
            dataSource = games
        case .searching:
            dataSource = searchedGames
        }
        return String(dataSource[indexPath.row].id)
    }
    
    internal func loadGameList() {
        self.viewState = .loading
        client.request(endpoint: .gameList(page: String(page), pageSize: String(pageSize)), method: .GET, expecting: GameResponse.self, body: Data()) { result in
            switch result {
            case .success(let response):
                self.games.append(contentsOf: response.data)
                self.viewState = .success
            case .failure(let error):
                self.games = []
                self.viewState = .error(error)
            }
        }
    }
    
    internal func searchGame(searchQuery: String) {
        if searchQuery != "" {
            self.viewState = .loading
            self.userState = .searching
            client.request(endpoint: .searchGame(search: searchQuery), method: .GET, expecting: GameResponse.self, body: Data()) { result in
                switch result {
                case .success(let response):
                    self.searchedGames = response.data
                    self.viewState = .success
                case .failure(let error):
                    self.searchedGames = []
                    self.viewState = .error(error)
                }
            }
        } else {
            self.userState = .normal
            self.viewState = .idle
        }
        
    }
    
    internal func paginate(indexPath: IndexPath) {
        if indexPath.row > games.count - 3 {
            page += 1
            loadGameList()
        }
    }
    
    internal func getNumberOfData() -> Int {
        switch userState {
        case .normal:
            return numberOfGames
        case.searching:
            return numberOfSearchedGames
        }
    }
}
