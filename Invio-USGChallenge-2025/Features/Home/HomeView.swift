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
        NavigationStack {
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
            .toolbar {
                ToolbarItemView(isNavigateToFavorite: $isNavigateToFavorite)
            }
            .navigationDestination(isPresented: $isNavigateToFavorite) {
                FavoriteView()
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

private struct ToolbarItemView: ToolbarContent {
    @Binding var isNavigateToFavorite: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Önemli Konumlar")
                .font(.headline)
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Image(systemName: "heart")
                .foregroundColor(.red)
                .onTapGesture {
                    isNavigateToFavorite = true
                }
        }
    }
}

#Preview {
    HomeView()
}
