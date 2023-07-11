//
//  FavoriteGameViewModel.swift
//  GameDB
//
//  Created by Hada Melino on 15/05/23.
//

import CoreData
import Foundation
import UIKit

final class FavoriteGameViewModel {
    
    weak var delegate: ViewModelOutput?
    private let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var viewState: ViewState {
        didSet {
            delegate?.updateView(with: viewState)
        }
    }
    internal var favoriteGames = [GameModel]()
    internal var numberOfFavoriteGames: Int {
        favoriteGames.count
    }
    
    init() {
        self.viewState = .idle
    }
}

extension FavoriteGameViewModel {
    
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
        
        guard favoriteGames.count > indexPath.row else { return emptyGame }
        let game = favoriteGames[indexPath.row]
        return (game.name,
                game.released,
                game.rating,
                game.backgroundImageURL)
    }
    
    internal func getID(for indexPath: IndexPath) -> String {
        return String(favoriteGames[indexPath.row].id)
    }
}

extension FavoriteGameViewModel {
    internal func deleteGame(for indexPath: IndexPath) {
        do {
            managedContext?.delete(favoriteGames[indexPath.row])
            try managedContext?.save()
            viewState = .success
        } catch {
            viewState = .error(error)
        }
    }
    
    internal func fetchFavoriteGame() {
        do {
            guard let results = try managedContext?.fetch(GameModel.fetchRequest()) else { return }
            favoriteGames = results
            viewState = .success
        } catch {
            viewState = .error(error)
        }
    }
    
    
}
