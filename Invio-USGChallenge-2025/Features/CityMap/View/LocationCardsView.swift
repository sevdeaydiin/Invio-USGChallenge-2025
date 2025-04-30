//
//  LocationCardsView.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/27/25.
//

import SwiftUI
import MapKit

struct LocationCardsView: View {
    let viewModel: CityMapViewModel
    @Binding var mapRegion: MKCoordinateRegion
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(viewModel.locations) { location in
                    HorizontalLocationCard(
                        location: location,
                        distance: viewModel.locationDistances[location.id] ?? "",
                        isSelected: location.id == viewModel.selectedLocationId
                    )
                    .onTapGesture {
                        viewModel.selectLocation(location.id)
                        mapRegion.center = CLLocationCoordinate2D(
                            latitude: location.coordinates.lat,
                            longitude: location.coordinates.lng
                        )
                    }
                }
            }
            .padding()
        }
    }
}
