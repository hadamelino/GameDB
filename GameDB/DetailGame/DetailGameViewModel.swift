//
//  DetailGameViewModel.swift
//  GameDB
//
//  Created by Hada Melino on 15/05/23.
//

import CoreData
import Foundation
import UIKit

final class DetailGameViewModel {
    
    weak var delegate: ViewModelOutput?
    private let client: ClientServiceProtocol
    private let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var id: String
    private var state: ViewState {
        didSet {
            self.delegate?.updateView(with: state)
        }
    }
    private var detailGame: Detail {
        didSet {
            detailGame.rating = detailGame.ratingOneDecimal()
        }
    }
    
    init(id: String, client: ClientServiceProtocol = API.Client.shared) {
        self.id = id
        self.state = .loading
        self.client = client
        self.detailGame = Detail()
    }
    
}

extension DetailGameViewModel {
    
    internal func loadDetail() {
        state = .loading
        client.request(endpoint: .gameDetail(gameID: self.id), method: .GET, expecting: Detail.self, body: Data()) { result in
            switch result {
            case .success(let response):
                self.detailGame = response
                self.state = .success
            case .failure(let error):
                self.detailGame = Detail()
                self.state = .error(error)
            }
        }
    }
    
    internal func getDetailInfo() -> Detail {
        return detailGame
    }
    
    internal func checkDetailIsFavorite() {
        do {
            guard let results = try managedContext?.fetch(GameModel.fetchRequest()) else { return }
            if results.isEmpty {
                detailGame.isFavorite = false
            }
            for favoriteGame in results {
                if favoriteGame.id == detailGame.id {
                    detailGame.isFavorite = true
                    break
                }
                detailGame.isFavorite = false
            }
            
        } catch {
            state = .error(error)
        }
    }

    internal func getIsFavorite() -> Bool {
        return detailGame.isFavorite
    }
    
    internal func toggleIsFavorite() {
        detailGame.isFavorite.toggle()
        switch detailGame.isFavorite {
        case true:
            addToFavoriteGame()
        case false:
            removeFromFavoriteGame()
        }
    }
    
    private func addToFavoriteGame() {
        if let managedContext {
            let newFavoriteGame = GameModel(context: managedContext)
            newFavoriteGame.id = Int64(detailGame.id)
            newFavoriteGame.name = detailGame.name
            newFavoriteGame.released = detailGame.released ?? ""
            newFavoriteGame.rating = detailGame.rating ?? 0
            newFavoriteGame.backgroundImageURL = detailGame.backgroundImageURL ?? ""
            do {
                try managedContext.save()
            } catch {
                state = .error(error)
            }
        }
    }
    
    private func removeFromFavoriteGame() {
        
        do {
            guard let managedContext = managedContext else { return }
            let results = try managedContext.fetch(GameModel.fetchRequest())
            for favoriteGame in results {
                if favoriteGame.id == detailGame.id {
                    managedContext.delete(favoriteGame)
                    try managedContext.save()
                    state = .success
                    break
                }
            }
        } catch {
            state = .error(error)
        }
        
    }
    
}


