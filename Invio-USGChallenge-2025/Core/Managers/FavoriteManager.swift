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
    // MARK: - Singleton instance of Favorite Manager
    static let shared = FavoriteManager()
    
    // Private initializer to enforce singleton usage
    private init() {}
    
    // Private computed property to get and set favorites from UserDefaults
    private var favorites: Set<Int> {
        get { Set(UserDefaults.favoriteKeys) }
        set { UserDefaults.favoriteKeys = Array(newValue) }
    }
    
    // MARK: - Adds a location id to the favorites list
    func addToFavorite(_ locationId: Int) {
        var currentFavorites = favorites
        currentFavorites.insert(locationId)
        favorites = currentFavorites
        NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
    }
    
    // MARK: - Removes a location id from the favorites list
    func removeFromFavorite(_ locationId: Int) {
        var currentFavorites = favorites
        currentFavorites.remove(locationId)
        favorites = currentFavorites
        NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
    }
    
    // MARK: - Checks if a location id is in the favorites list
    func isFavorite(_ locationId: Int) -> Bool {
        favorites.contains(locationId)
    }
    
    // MARK: - Retrieves all favorite location id's
    func getAllFavorites() -> Set<Int> {
        favorites
    }  
}
