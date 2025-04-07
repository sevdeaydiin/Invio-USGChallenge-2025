//
//  NetworkError.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/6/25.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case failedResponse(statusCode: Int)
    case rateLimitExceeded
    case decodedFailed(errorDescription: String)
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            "Invalid URL Error Check Your URL"
        case .invalidResponse:
            "Invalid Response Check Your Request"
        case .failedResponse(let statusCode):
            "Failed Response with Status Code: \(statusCode)"
        case .rateLimitExceeded:
            "Rate Limit Exceeded You Can Try Again In 1-2 Hours"
        case .decodedFailed(let errorDescription):
            "Decode Failed with DecodeError: \n\(errorDescription)\n"
        }
    }
}
