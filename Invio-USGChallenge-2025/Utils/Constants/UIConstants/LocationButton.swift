//
//  LocationButton.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/19/25.
//

import SwiftUI

struct LocationButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "scope")
                .font(.title2)
                .foregroundStyle(.blue)
                .padding(3)
                .background(Circle().fill(Color.white).shadow(radius: 5))
        }
        .padding(.trailing, 20)
    }
}
