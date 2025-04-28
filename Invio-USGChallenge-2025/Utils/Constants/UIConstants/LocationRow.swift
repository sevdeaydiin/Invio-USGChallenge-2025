//
//  LocationRow.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/9/25.
//

import SwiftUI
import Kingfisher

struct LocationRow: View {
    enum Style {
        case compact    // Simple view on home view
        case expanded   // Detailed view on favorite view
    }
    
    let location: Location
    let isFavorite: Bool
    let style: Style
    let onFavoriteToggle: () -> Void
    let onRowTap: () -> Void
    
    init(
        location: Location,
        isFavorite: Bool,
        style: Style = .compact,
        onFavoriteToggle: @escaping () -> Void,
        onRowTap: @escaping () -> Void = {}
    ) {
        self.location = location
        self.isFavorite = isFavorite
        self.style = style
        self.onFavoriteToggle = onFavoriteToggle
        self.onRowTap = onRowTap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Text(location.name)
                    .font(style == .compact ? .title3 : .headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: onFavoriteToggle) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .primary)
                        .scaleEffect(isFavorite ? 1.2 : 1)
                        .animation(.easeInOut, value: isFavorite)
                }
            }
        }
        .padding(.horizontal, style == .compact ? 16 : 12)
        .padding(.vertical, style == .compact ? 3 : 8)
        .background(
            RoundedRectangle(cornerRadius: style == .compact ? 5 : 12)
                .stroke(style == .compact ? .primary : .secondary)
                .background(
                    RoundedRectangle(cornerRadius: style == .compact ? 5 : 12)
                        .fill(.background)
                )
                .shadow(radius: style == .expanded ? 2 : 0)
        )
        .padding(.horizontal)
        .padding(.leading, style == .compact ? 30 : 0)
        .onTapGesture {
            onRowTap()
        }
    }
}
