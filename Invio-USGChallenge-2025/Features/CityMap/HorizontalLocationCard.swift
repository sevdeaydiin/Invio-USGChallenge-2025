//
//  HorizontalLocationView.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/19/25.
//

import SwiftUI
import Kingfisher

struct HorizontalLocationCard: View {
    let action: () -> Void
    let location: Location
    
    var body: some View {
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
                    .frame(width: 80, height: 60)
                    .cornerRadius(10)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.black)
                    .frame(width: 80, height: 60)
                    .cornerRadius(10)
            }

            VStack(spacing: 10) {
                Text(location.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 150)
                
                CustomButton(buttonText: "Detaya Git", height: 30, action: action)
            }
        }
        .padding(.vertical)
        .padding(.horizontal)
        .frame(maxWidth: 300)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
    }
}
