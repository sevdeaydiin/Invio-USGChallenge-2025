//
//  CityLocation.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/6/25.
//

import Foundation

struct CityResponse: Codable {
    let currentPage: Int
    let totalPage: Int
    let total: Int
    let itemPerPage: Int
    let pageSize: Int
    let data: [City]
}

struct City: Codable {
    let city: String
    let locations: [Location]
}

struct Location: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
    let coordinates: Coordinates
    let image: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}

struct Coordinates: Codable, Hashable {
    let lat: Double
    let lng: Double
}

extension CityResponse {
    static var mockData: Self {
        .init(
            currentPage: 1,
            totalPage: 4,
            total: 62,
            itemPerPage: 20,
            pageSize: 20,
            data: [City(city: "Konya", locations: [Location(id: 171, name: "Mevlana Müzesi", description: "Mevlana Celaleddin Rumi'nin türbesinin bulunduğu, İslam dünyasının önemli müzelerinden.", coordinates: Coordinates(lat: 37.8706, lng: 32.5045), image: "https://www.kulturportali.gov.tr/contents/images/Konya_Mevlana_M%C3%BCzesi%20(1)%20kopya.jpg")])])
    }
}
