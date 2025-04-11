//
//  HomeViewModel.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/9/25.
//

import Foundation

final class HomeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published private(set) var cities: [City] = []
    @Published private(set) var favoriteLocations: Set<Int> = [] // Location ID
    
    // MARK: - Dependencies
    private let store = CityLocationStore.shared
    private let favoriteManager = FavoriteManager.shared
    
    // MARK: - Initialization
    init() {
        self.cities = store.cities
    }
    
    // MARK: - Favorite Methods
    func toggleFavorite(for location: Location) {
        if favoriteManager.isFavorite(location.id) {
            favoriteManager.removeFromFavorite(location.id)
        } else {
            favoriteManager.addToFavorite(location.id)
        }
        objectWillChange.send()
    }
    
    func isLocationFavorite(_ location: Location) -> Bool {
        favoriteManager.isFavorite(location.id)
    }
}

// MARK: - Helper Methods
extension HomeViewModel {
    func hasLocations(for city: City) -> Bool {
        !city.locations.isEmpty
    }
}
