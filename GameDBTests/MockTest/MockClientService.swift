//
//  MockClientService.swift
//  GameDBTests
//
//  Created by Hada Melino on 17/05/23.
//

@testable import GameDB
import Foundation

final class MockClientService: ClientServiceProtocol {
    
    var result: Any!
    
    func request<T>(endpoint: GameDB.API.Types.Endpoint, method: GameDB.API.Types.Method, expecting: T.Type, body: Data, completionHandler: @escaping ((Result<T, Error>) -> Void)) where T : Decodable {
        completionHandler(result as! Result<T, Error>)
    }
}
