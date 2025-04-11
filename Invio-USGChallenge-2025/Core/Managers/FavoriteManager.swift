//
//  FavoriteManager.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/10/25.
//

import Foundation

protocol FavoriteManagerProtocol {
    func addToFavorite(_ locationId: Int)
    func removeFromFavorite(_ locationId: Int)
    func isFavorite(_ locationId: Int) -> Bool
    func getAllFavorites() -> Set<Int>
}

final class FavoriteManager: FavoriteManagerProtocol {
    static let shared = FavoriteManager()
    
    private init() {}
    
    private var favorites: Set<Int> {
        get { Set(UserDefaults.favoriteKeys) }
        set { UserDefaults.favoriteKeys = Array(newValue) }
    }
    
    func addToFavorite(_ locationId: Int) {
        var currentFavorites = favorites
        currentFavorites.insert(locationId)
        favorites = currentFavorites
    }
    
    func removeFromFavorite(_ locationId: Int) {
        var currentFavorites = favorites
        currentFavorites.remove(locationId)
        favorites = currentFavorites
    }
    
    func isFavorite(_ locationId: Int) -> Bool {
        favorites.contains(locationId)
    }
    
    func getAllFavorites() -> Set<Int> {
        favorites
    }  
}
