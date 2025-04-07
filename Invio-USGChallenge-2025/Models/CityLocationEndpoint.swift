//
//  CityLocationEndpoint.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/6/25.
//

import Foundation

enum CityLocationEndpoint: Endpoint {
    case getCityLocations(page: Int) // Fetch All City Location
    
    var path: String {
        switch self {
        case .getCityLocations(let page):
            return "page-\(page).json"
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
}
