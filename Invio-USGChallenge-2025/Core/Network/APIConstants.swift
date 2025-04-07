//
//  APIConstants.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/7/25.
//

import Foundation

enum APIConstants {
    
    static let baseURL = "storage.googleapis.com"
    static let path = "/invio-com/usg-challenge/city-location/"
    
    enum Headers {
        static let contentType = "Content-Type"
        static let applicationJSON = "application/json"
    }
}
