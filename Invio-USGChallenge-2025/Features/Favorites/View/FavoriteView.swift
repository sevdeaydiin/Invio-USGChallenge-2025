//
//  FavoriteView.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/10/25.
//

import SwiftUI

struct FavoriteView: View {
    @StateObject private var viewModel = FavoriteViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLocation: Location?
    
    var body: some View {
        ScrollView {
            if viewModel.hasFavorite {
                LazyVStack {
                    ForEach(viewModel.favoriteLocations) { location in
                        LocationRow(
                            location: location,
                            isFavorite: true,
                            style: .expanded,
                            onFavoriteToggle: {
                                viewModel.removeFavorite(location)
                            },
                            onRowTap: {
                                selectedLocation = location
                            }
                        )
                    }.padding(.top, 1)
                }
            } else {
                Text("Henüz hiç bir konumu favorilere eklemedin!")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.vertical)
            }
        }
        .navigationDestination(isPresented: Binding(
            get: { selectedLocation != nil },
            set: { if !$0 { selectedLocation = nil } }
        )) {
            if let location = selectedLocation {
                DetailView(location: location)
                    .navigationBarBackButtonHidden()
            }
        }
        .navigationTitle("Favorilerim")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                }
                .foregroundStyle(.primary)
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    FavoriteView()
}
