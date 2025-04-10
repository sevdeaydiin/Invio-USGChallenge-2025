//
//  LocationRow.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/9/25.
//

import SwiftUI

struct LocationRow: View {
    let location: Location
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Text(location.name)
                .foregroundColor(.black)
            Spacer()
            Button(action: onFavoriteToggle) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .black)
            }
        }
        .font(.title3)
        .padding(.horizontal)
        .padding(.vertical, 3)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(.black)
        )
        .padding(.horizontal)
        .padding(.leading, 30)
    }
}
