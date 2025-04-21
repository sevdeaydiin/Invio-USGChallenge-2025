//
//  CustomButton.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/11/25.
//

import SwiftUI

struct CustomButton: View {
    let buttonText: String
    let height: CGFloat?
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(buttonText)
                .font(.callout)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: height ?? 50)
                .foregroundStyle(.black)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.lavender)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.violetBlue)
                }
        }
        .padding(.horizontal)
    }
}
