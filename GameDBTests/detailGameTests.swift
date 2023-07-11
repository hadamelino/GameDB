//
//  detailGameTests.swift
//  GameDBTests
//
//  Created by Hada Melino on 17/05/23.
//

import XCTest
@testable import GameDB

final class detailGameTests: XCTestCase {
    
    var sut: DetailGameViewModel!
    var mockClientService: MockClientService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockClientService = MockClientService()
        sut = DetailGameViewModel(id: "0", client: mockClientService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockClientService = nil
        sut = nil
    }
    
    func testSuccessLoadDetailGame() {
        let detail = Detail(name: "Valorant")
  
        mockClientService.result = .success(Detail(name: "Valorant")) as Result<Detail, Error>
        
        sut.loadDetail()
        
        XCTAssertEqual(detail, sut.getDetailInfo())
    }
    
    func testFailedLoadDetailGame() {
        let detail = Detail(name: "Valorant")
        
        mockClientService.result = .failure(API.Types.CustomError.failedToLoadGameDetail) as Result<Detail, Error>
        sut.loadDetail()
        
        XCTAssertNotEqual(detail, sut.getDetailInfo())
        XCTAssertEqual(Detail(), sut.getDetailInfo())
    }
    
    func testSaveToFavoriteGame() {
        let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        
        let newFavoriteGame = GameModel(context: context)
        newFavoriteGame.id = Int64(0)
        newFavoriteGame.name = "Valorant"
        newFavoriteGame.released = "2022"
        newFavoriteGame.rating = 4.5
        newFavoriteGame.backgroundImageURL = "www.testimage1.com"
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
            return true
        }
        
        context.insert(newFavoriteGame)
        try! context.save()
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }
    
    func testTheDisplayedDetailGameIsFavorited() {
        
        let displayedDetailID = Int64(0)
        
        let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        
        let newFavoriteGame = GameModel(context: context)
        newFavoriteGame.id = Int64(0)
        newFavoriteGame.name = "Valorant"
        newFavoriteGame.released = "2022"
        newFavoriteGame.rating = 4.5
        newFavoriteGame.backgroundImageURL = "www.testimage1.com"
        
        context.insert(newFavoriteGame)
        try! context.save()
        
        let results = try! context.fetch(GameModel.fetchRequest())
        
        for result in results {
            XCTAssertEqual(result.id, displayedDetailID)
        }
    }
    
    func testTheDisplayedDetailGameIsNotFavorited() {
        
        let displayedDetailID = Int64(1)
        
        let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        
        let newFavoriteGame = GameModel(context: context)
        newFavoriteGame.id = Int64(0)
        newFavoriteGame.name = "Valorant"
        newFavoriteGame.released = "2022"
        newFavoriteGame.rating = 4.5
        newFavoriteGame.backgroundImageURL = "www.testimage1.com"
        
        context.insert(newFavoriteGame)
        try! context.save()
        
        let results = try! context.fetch(GameModel.fetchRequest())
        
        for result in results {
            XCTAssertNotEqual(result.id, displayedDetailID)
        }
    }
}
