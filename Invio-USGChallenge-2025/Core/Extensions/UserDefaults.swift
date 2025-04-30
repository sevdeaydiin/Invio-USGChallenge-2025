//
//  UserDefaults.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/9/25.
//

import Foundation

extension UserDefaults {
    public enum Keys {
        static let favoriteKeys = "favoriteLocations"
        static let cachedCityData = "cachedCityData"
        static let hasRequestedLocationPermission = "hasRequestedLocationPermission"
    }
    
    @UserDefault(key: Keys.favoriteKeys, defaultValue: [])
    static var favoriteKeys: [Int]
    
    @UserDefault(key: Keys.cachedCityData, defaultValue: [])
    static var cachedCityData: [City]
    
    @UserDefault(key: Keys.hasRequestedLocationPermission, defaultValue: false)
    static var hasRequestedLocationPermission: Bool
}
