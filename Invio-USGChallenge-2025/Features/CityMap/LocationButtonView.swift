//
//  LocationButtonView.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/27/25.
//

import SwiftUI
import MapKit

struct LocationButtonView: View {
    let viewModel: CityMapViewModel
    @Binding var mapRegion: MKCoordinateRegion
    
    var body: some View {
        LocationButton {
            viewModel.handleLocationButtonTap()
        }
    }
}
