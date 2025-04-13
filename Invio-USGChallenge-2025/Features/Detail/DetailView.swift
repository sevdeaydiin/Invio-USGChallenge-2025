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

    init(location: Location) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(location: location))
    }

    var body: some View {
        VStack(spacing: 30) {
            if let imageUrl = viewModel.imageUrl {
                KFImage(URL(string: imageUrl))
                    .placeholder {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(height: 250)
                    }
                    .setupCache()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                
                    .clipped()
                    .padding(.top, 20)
            }
            
            Text(viewModel.description)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            Spacer()
            
            CustomButton(buttonText: "Haritada Göster") {
                // Map button
            }
            
        }
        .padding(.horizontal, 20)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(viewModel.name)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite ? .red : .black)
                }
            }
        }
        // TODO: - Map View
//        .navigationDestination(isPresented: $showMap) {
//            //LocationMapView(location: viewModel.location)
//        }
    }
}
