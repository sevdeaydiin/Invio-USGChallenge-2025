//
//  CityLocation.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/6/25.
//

import Foundation

struct CityResponse: Decodable {
    let currentPage: Int
    let totalPage: Int
    let total: Int
    let itemPerPage: Int
    let pageSize: Int
    let data: [City]
}

struct City: Decodable {
    let city: String
    let locations: [Location]
}

struct Location: Decodable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let coordinates: Coordinates
    let image: String?
}

struct Coordinates: Decodable {
    let lat: Double
    let lng: Double
}
