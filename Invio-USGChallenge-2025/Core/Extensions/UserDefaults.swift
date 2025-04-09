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
    }
    
    @UserDefault(key: Keys.favoriteKeys, defaultValue: [])
    static var favoriteKeys: [Int]
}
