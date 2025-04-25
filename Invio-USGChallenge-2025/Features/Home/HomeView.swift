//
//  HomeView.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/7/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var navigationPath = NavigationPath()
    @State private var isNavigateToFavorite = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
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
                    
                    // Loading indicator and next page trigger
                    if !viewModel.cities.isEmpty {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                        }
                        .frame(height: 50)
                        .onAppear {
                            Task {
                                await viewModel.loadMoreContentIfNeeded()
                            }
                        }
                    }
                }
            }
            .background(.background)
            .toolbar {
                ToolbarItemView(isNavigateToFavorite: $isNavigateToFavorite)
            }
            .navigationTitle("Önemli Konumlar")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isNavigateToFavorite) {
                FavoriteView()
                    .navigationBarBackButtonHidden()
            }
            .navigationDestination(for: Location.self) { location in
                DetailView(location: location)
                    .navigationBarBackButtonHidden()
            }
            .navigationDestination(for: String.self) { cityName in
                if let city = viewModel.cities.first(where: { $0.city == cityName }) {
                    CityMapView(viewModel: CityMapViewModel(cityName: cityName, locations: city.locations))
                        .navigationBarBackButtonHidden()
                }
            }
        }
    }
}

private struct ToolbarItemView: ToolbarContent {
    @Binding var isNavigateToFavorite: Bool
    
    var body: some ToolbarContent {
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
