//
//  CityCell.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/9/25.
//

import SwiftUI

struct CityCell: View {
    @State private var isExpanded = false
    @State private var isNavigateToDetail = false
    let cityName: String
    let hasLocations: Bool
    let locations: [Location]
    let isFavorite: (Location) -> Bool
    let onFavoriteToggle: (Location) -> Void
    
    var body: some View {
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
                isNavigateToDetail = true
            } label: {
                Image(systemName: "chevron.right")
            }
            
            // MARK: Navigate to Detail View
            NavigationLink(
                destination: DetailView()
                    .navigationBarBackButtonHidden(true),
                isActive: $isNavigateToDetail) {
                EmptyView()
            }
        }
        .padding(.vertical, 5)
        .foregroundColor(.black)
        .font(.headline)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(.black)
        )
        .padding(.horizontal)
        .padding(.vertical, 1)
        
        // MARK: - If there is a location in the city
        if isExpanded {
            ForEach(locations) { location in
                LocationRow(
                    location: location,
                    isFavorite: isFavorite(location),
                    onFavoriteToggle: { onFavoriteToggle(location) })
            }
        }
    }
}
