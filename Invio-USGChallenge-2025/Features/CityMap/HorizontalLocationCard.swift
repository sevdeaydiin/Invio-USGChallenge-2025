//
//  HorizontalLocationView.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/19/25.
//

import SwiftUI
import Kingfisher

struct HorizontalLocationCard: View {
    let location: Location
    let distance: String
    let isSelected: Bool
    @State private var isNavigateToDetail: Bool = false
    
    var body: some View {
        NavigationStack {
            HStack(spacing: 10) {
                if let imageURL = location.image, let url = URL(string: imageURL) {
                    KFImage(url)
                        .setupCache()
                        .placeholder { _ in
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                        }
                        .frame(width: 90, height: 70)
                        .cornerRadius(10)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.black)
                        .frame(width: 90, height: 70)
                        .cornerRadius(10)
                }

                VStack(spacing: distance.isEmpty ? 10 : 3) {
                    Text(location.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 150)
                    
                    if !distance.isEmpty {
                        Text(distance)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    CustomButton(buttonText: "Detaya Git", height: 30) {
                        isNavigateToDetail = true
                    }
                }
            }
            .padding(.vertical)
            .padding(.horizontal)
            .frame(maxWidth: 300)
            .background(RoundedRectangle(cornerRadius: 10).fill(.background).shadow(radius: 5))
            .navigationDestination(isPresented: $isNavigateToDetail) {
                DetailView(location: location)
            }
            
        }
    }
}
