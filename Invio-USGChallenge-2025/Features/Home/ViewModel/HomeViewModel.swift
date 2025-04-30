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
    @Published private(set) var isLoading = false
    @Published private(set) var currentPage = 1
    @Published private(set) var hasMorePages = true
    
    // MARK: - Dependencies
    private let store = CityLocationStore.shared
    private let favoriteManager = FavoriteManager.shared
    private let networkManager: NetworkService
    
    // MARK: - Initialization
    init(networkManager: NetworkService = NetworkManager()) {
        self.networkManager = networkManager
        self.cities = store.cities
    }
    
    // MARK: - Data Fetching
    func loadMoreContentIfNeeded() async {
        guard !isLoading && hasMorePages else { return }
        
        await MainActor.run {
            isLoading = true
        }
        
        do {
            let cityResponse: CityResponse = try await networkManager.fetch(
                with: CityLocationEndpoint.getCityLocations(page: currentPage + 1)
            )
            
            await MainActor.run {
                cities.append(contentsOf: cityResponse.data)
                store.cities.append(contentsOf: cityResponse.data)
                currentPage = cityResponse.currentPage
                hasMorePages = currentPage < cityResponse.totalPage
                isLoading = false
                NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
            }
        } catch {
            await MainActor.run {
                isLoading = false
            }
            print("Error loading more content: \(error)")
        }
    }
    
    // MARK: - Favorite Methods
    func toggleFavorite(for location: Location) {
        if favoriteManager.isFavorite(location.id) {
            favoriteManager.removeFromFavorite(location.id)
        } else {
            favoriteManager.addToFavorite(location.id)
        }
        objectWillChange.send()
        NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
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
