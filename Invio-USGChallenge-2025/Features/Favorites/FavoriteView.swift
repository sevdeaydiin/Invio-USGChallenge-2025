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
        .navigationTitle("Favorilerim")
        .navigationBarItems(
            leading:Button(
                action: { dismiss() }) {
                    Image(systemName: "arrow.backward")
                        .foregroundStyle(.black)
                }
        )
    }
}

#Preview {
    FavoriteView()
}
