//
//  favoriteGameTests.swift
//  GameDBTests
//
//  Created by Hada Melino on 17/05/23.
//

import XCTest
@testable import GameDB

final class favoriteGameTests: XCTestCase {
    

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDeleteFavoriteGame() {
        let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        
        let newFavoriteGame = GameModel(context: context)
        newFavoriteGame.id = Int64(0)
        newFavoriteGame.name = "Valorant"
        newFavoriteGame.released = "2022"
        newFavoriteGame.rating = 4.5
        newFavoriteGame.backgroundImageURL = "www.testimage1.com"
        
        context.insert(newFavoriteGame)
        try! context.save()
        
        var results = try! context.fetch(GameModel.fetchRequest())
        
        XCTAssertEqual(newFavoriteGame, results.first)
        
        context.delete(newFavoriteGame)
        try! context.save()
        
        results = try! context.fetch(GameModel.fetchRequest())
        XCTAssertEqual([], results)
    }
    
}
