//
//  HomeView.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/7/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isNavigateToFavorite = false
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.cities, id: \.city) { city in
                    CityCell(
                        cityName: city.city,
                        hasLocations: viewModel.hasLocations(for: city),
                        locations: city.locations,
                        isFavorite: { location in viewModel.isLocationFavorite(location) },
                        onFavoriteToggle: { location in viewModel.toggleFavorite(for: location) }
                    )
                }
            }
        }
        .navigationTitle("Önemli Konumlar")
        .navigationBarItems(
            trailing: Button {
                isNavigateToFavorite = true
            } label: {
                Image(systemName: "heart")
                    .foregroundColor(.red)
            }
        )
        
        // MARK: - Navigate to Favorite View
        NavigationLink(
            destination: FavoriteView()
                .navigationBarBackButtonHidden(true),
            isActive: $isNavigateToFavorite) {
                EmptyView()
            } 
    }
}

#Preview {
    HomeView()
}
