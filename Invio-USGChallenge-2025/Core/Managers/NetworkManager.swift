//
//  NetworkManager.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/6/25.
//

import Foundation

protocol NetworkService: AnyObject {
    func fetch<T: Decodable>(with endpoint: Endpoint) async throws -> T
}

final class NetworkManager: NetworkService {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    private lazy var jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }()
    
    func fetch<T: Decodable>(with endpoint: Endpoint) async throws -> T {
        guard let urlRequest = endpoint.createURLRequest() else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        print(data)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...290).contains(httpResponse.statusCode) else {
            throw NetworkError.failedResponse(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decodedResponse = try jsonDecoder.decode(T.self, from: data)
            print(decodedResponse)
            return decodedResponse
        } catch {
            throw NetworkError.decodedFailed(errorDescription: error.localizedDescription)
        }
    }
}
