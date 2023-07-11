//
//  GameDBTests.swift
//  GameDBTests
//
//  Created by Hada Melino on 15/05/23.
//

import XCTest
@testable import GameDB

final class GameDBTests: XCTestCase {
    
    var sut: ListGameViewModel!
    var mockClientService: MockClientService!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockClientService = MockClientService()
        sut = ListGameViewModel(client: mockClientService)
    }

    override func tearDownWithError() throws {
        mockClientService = nil
        sut = nil
    }
    
    func testSuccessfulLoadGameListUnempty() {
        let data = [Game(id: 0, name: "Valorant"), Game(id: 1, name: "Apex Legends")]
        mockClientService.result = .success(GameResponse(data: data)) as Result<GameResponse, Error>
        
        sut.loadGameList()
        XCTAssertEqual(data, sut.games)
        XCTAssertEqual(2, sut.numberOfGames)
    }
    
    func testSuccessfulLoadGameListEmpty() {
        let data = [Game]()
        mockClientService.result = .success(GameResponse(data: data)) as Result<GameResponse, Error>
        
        sut.loadGameList()
        XCTAssertEqual(data, sut.games)
        XCTAssertEqual(0, sut.numberOfGames)
    }
    
    func testErrorLoadGameList() {
        let data = [Game]()
        mockClientService.result = .failure(API.Types.CustomError.failedToLoadGameList) as Result<GameResponse, Error>
        
        XCTAssertEqual(data, sut.games)
        XCTAssertEqual(0, sut.numberOfGames)
    }
    
    func testSuccessfulSearchGame(){
        let data = [Game(id: 0, name: "Valorant")]
        mockClientService.result = .success(GameResponse(data: data)) as Result<GameResponse, Error>
        
        sut.searchGame(searchQuery: "Valorant")
        XCTAssertEqual(data, sut.searchedGames)
        XCTAssertEqual(1, sut.numberOfSearchedGames)
    }
    
    func testFailedSearchGame() {
        let data = [Game]()
        mockClientService.result = .failure(API.Types.CustomError.failedToSearchGames) as Result<GameResponse, Error>
        
        sut.searchGame(searchQuery: "Valorant")
        XCTAssertEqual(data, sut.searchedGames)
        XCTAssertEqual(0, sut.numberOfSearchedGames)
    }
    
    func testGetSuccessfulInfoForDataSourceToTableView() {
        sut.games = [Game(id: 0, name: "Valorant", released: "2022", rating: 4.5, backgroundImageURL: "www.testimage.com"),
                           Game(id: 1, name: "Apex Legends", released: "2021", rating: 4, backgroundImageURL: "www.testimage1.com")]
        
        let indexPath = IndexPath(row: 1, section: 0)
        
        let info = sut.getInfo(for: indexPath)
        let data = sut.games[indexPath.row]
        
        XCTAssertNotNil(info.name)
        XCTAssertNotNil(info.released)
        XCTAssertNotNil(info.rating)
        XCTAssertNotNil(info.backgroundImageURL)
        
        XCTAssertEqual(data.name, info.name)
        XCTAssertEqual(data.released, info.released)
        XCTAssertEqual(data.rating, info.rating)
        XCTAssertEqual(data.backgroundImageURL, info.backgroundImageURL)

    }
    
    func testGetFailedInfoForDataSourceTableView() {
        sut.games = [Game(id: 0, name: "Valorant", released: "2022", rating: 4.5, backgroundImageURL: "www.testimage.com"),
                           Game(id: 1, name: "Apex Legends", released: "2021", rating: 4, backgroundImageURL: "www.testimage1.com")]
        
        let indexPath = IndexPath(row: 2, section: 0)
        
        let info = sut.getInfo(for: indexPath)
        
        XCTAssertEqual("", info.name)
        XCTAssertEqual("", info.released)
        XCTAssertEqual(0, info.rating)
        XCTAssertEqual("", info.backgroundImageURL)
    }
    
}
