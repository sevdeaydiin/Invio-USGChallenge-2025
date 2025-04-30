//
//  DetailView.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/9/25.
//

import SwiftUI
import Kingfisher

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: DetailViewModel
    @State private var showMap = false
    private var isLandscape = UIDevice.current.orientation.isLandscape
    
    init(location: Location) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(location: location))
    }
    
    var body: some View {
        VStack(spacing: isLandscape ? 10 : 30) {
            if let imageUrl = viewModel.imageUrl {
                KFImage(URL(string: imageUrl))
                    .placeholder {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(maxHeight: isLandscape ? .infinity : 250)
                            .foregroundStyle(.secondary)
                    }
                    .setupCache()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: isLandscape ? .infinity : 250)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(height: isLandscape ? 150 : 250)
                    .foregroundStyle(.secondary)
            }
            
            Text(viewModel.description)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            Spacer()
            
            CustomButton(buttonText: "Haritada Göster", height: 50) {
                showMap = true
            }
            .padding(.bottom, isLandscape ? 10 : 0)
        }
        .padding(.horizontal, isLandscape ? 50 : 20)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(viewModel.name)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite ? .red : .primary)
                }
            }
        }
        .navigationDestination(isPresented: $showMap) {
            LocationMapView(location: viewModel.location)
                .navigationBarBackButtonHidden()
        }
    }
}
