//
//  FavoriteViewModel.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/10/25.
//

import Foundation

final class FavoriteViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var favoriteLocations: [Location] = []
    
    // MARK: - Dependencies
    private let store = CityLocationStore.shared
    private let favoriteManager = FavoriteManager.shared
    
    // MARK: - Initialization
    init() {
        loadFavoriteLocations()
        setupNotificationObserver()
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFavoriteStatusChanged),
            name: NSNotification.Name("FavoriteStatusChanged"),
            object: nil
        )
    }
    
    @objc private func handleFavoriteStatusChanged() {
        loadFavoriteLocations()
    }
    
    private func loadFavoriteLocations() {
        let favoriteIds = favoriteManager.getAllFavorites()
        
        favoriteLocations = store.cities.flatMap { city in
            city.locations.filter { location in
                favoriteIds.contains(location.id)
            }
        }
    }
    
    func removeFavorite(_ location: Location) {
        favoriteManager.removeFromFavorite(location.id)
        loadFavoriteLocations()
    }
    
    var hasFavorite: Bool {
        !favoriteLocations.isEmpty
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
