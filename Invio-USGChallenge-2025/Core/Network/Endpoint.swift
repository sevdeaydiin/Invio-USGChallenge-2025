//
//  Endpoint.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/6/25.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var scheme: String { get }
    var httpMethod: HTTPMethod { get }
    var queryParameters: [String: String]? { get }
    var headers: [String: String]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension Endpoint {
    var baseURL: String {
        APIConstants.baseURL
    }
    
    var scheme: String {
        "https"
    }
    
    var headers: [String: String]? {
        [
            "Content-Type": APIConstants.Headers.contentType,
            "Accept": APIConstants.Headers.applicationJSON
        ]
    }
    
    var queryParameters: [String: String]? {
        return nil
    }
    
    func createURLRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.path = APIConstants.path + path
        urlComponents.host = baseURL
        
        if let queryParameters = queryParameters {
            urlComponents.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers
        print(urlRequest)
        return urlRequest
    }
}
