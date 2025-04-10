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
    
    // MARK: - Initialization
    init() {
        self.cities = store.cities
        loadFavorites()
    }
    
    // MARK: - Favorite Methods
    func toggleFavorite(for location: Location) {
        if favoriteLocations.contains(location.id) {
            favoriteLocations.remove(location.id)
        } else {
            favoriteLocations.insert(location.id)
        }
        saveFavorites()
    }
    
    func isLocationFavorite(_ location: Location) -> Bool {
        favoriteLocations.contains(location.id)
    }
    
    private func loadFavorites() {
        favoriteLocations = Set(UserDefaults.favoriteKeys)
    }
    
    private func saveFavorites() {
        UserDefaults.favoriteKeys = Array(favoriteLocations)
    }
}

// MARK: - Helper Methods
extension HomeViewModel {
    func hasLocations(for city: City) -> Bool {
        !city.locations.isEmpty
    }
}
