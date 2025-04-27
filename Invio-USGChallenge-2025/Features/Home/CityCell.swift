//
//  CityCell.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/9/25.
//

import SwiftUI

struct CityCell: View {
    @State private var isExpanded = false
    let cityName: String
    let hasLocations: Bool
    let locations: [Location]
    let isFavorite: (Location) -> Bool
    let onFavoriteToggle: (Location) -> Void
    let onRowTap: (Location) -> Void
    let onMapButtonTap: () -> Void
    
    var body: some View {
        VStack {
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
                    onMapButtonTap()
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
            
            // MARK: - If there is a location in the city
            if isExpanded {
                ForEach(locations) { location in
                    LocationRow(
                        location: location,
                        isFavorite: isFavorite(location),
                        style: .compact,
                        onFavoriteToggle: { onFavoriteToggle(location) },
                        onRowTap: {
                            onRowTap(location)
                        }
                    )
                }
                .padding(.bottom, 1)
            }
        }
    }
}
