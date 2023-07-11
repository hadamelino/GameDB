//
//  APIClient.swift
//  GameDB
//
//  Created by Hada Melino on 15/05/23.
//

import Foundation
import UIKit

protocol ClientServiceProtocol {
    func request<T: Decodable>(endpoint: API.Types.Endpoint, method: API.Types.Method, expecting: T.Type, body: Data, completionHandler: @escaping ((Result<T, Error>) -> Void))
}

extension API {
    
    internal class Client: ClientServiceProtocol {
        
        static let shared = Client()
        
        private var headers = [
            "Accept": "application/json",
        ]
                
        internal func request<T: Decodable> (
            endpoint: API.Types.Endpoint,
            method: API.Types.Method,
            expecting: T.Type,
            body: Data,
            completionHandler: @escaping ((Result<T, Error>) -> Void)
        ) {
            var request = URLRequest(url: endpoint.url)
            request.httpMethod = method.rawValue
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completionHandler(.failure(error))
                }
                guard let data = data else { return }
                do {
                    let result = try JSONDecoder().decode(expecting, from: data)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
            }
            task.resume()
        }

    }
    
}
