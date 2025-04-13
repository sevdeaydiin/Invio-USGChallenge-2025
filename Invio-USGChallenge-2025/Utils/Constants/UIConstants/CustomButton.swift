//
//  CustomButton.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/11/25.
//

import SwiftUI

struct CustomButton: View {
    let buttonText: String
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Text(buttonText)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 50)
                .foregroundStyle(.black)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.cyan.opacity(0.3))
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.cyan)
                }
        }
    }
}
