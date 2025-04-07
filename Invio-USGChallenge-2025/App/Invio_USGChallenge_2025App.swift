//
//  Invio_USGChallenge_2025App.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/5/25.
//

import SwiftUI

@main
struct Invio_USGChallenge_2025App: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: CityLocationViewModel(
                    networkManager: NetworkManager(),
                    cacheManager: CacheManager(),
                    imageDownloadManager: ImageDownloadManager())
            )
        }
    }
}
