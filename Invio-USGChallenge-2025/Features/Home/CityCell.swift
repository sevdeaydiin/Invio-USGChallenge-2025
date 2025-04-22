//
//  CityCell.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/9/25.
//

import SwiftUI

struct CityCell: View {
    @State private var isExpanded = false
    @State private var isNavigateToMap = false
    let cityName: String
    let hasLocations: Bool
    let locations: [Location]
    let isFavorite: (Location) -> Bool
    let onFavoriteToggle: (Location) -> Void
    
    var body: some View {
        NavigationStack {
            HStack {
                if hasLocations {
                    Button {
                        isExpanded.toggle()
                    } label: {
                        Image(systemName: isExpanded ? "minus" : "plus" )
                    }
                }
                
                Text(cityName.uppercased())
                    .font(.title2)
                
                Spacer()
                
                Button {
                    Task { @MainActor in
                        isNavigateToMap = true
                    }
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.vertical, 5)
            .foregroundColor(.primary)
            .font(.headline)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.primary)
            )
            .padding(.horizontal)
            .padding(.bottom, 2)
            .navigationDestination(isPresented: $isNavigateToMap) {
                CityMapView(viewModel: CityMapViewModel(cityName: cityName, locations: locations))
                    .navigationBarBackButtonHidden()
            }
            
            // MARK: - If there is a location in the city
            if isExpanded {
                ForEach(locations) { location in
                    LocationRow(
                        location: location,
                        isFavorite: isFavorite(location),
                        style: .compact,
                        onFavoriteToggle: { onFavoriteToggle(location) }
                    )
                }
                .padding(.bottom, 1)
            }
        }
    }
}
