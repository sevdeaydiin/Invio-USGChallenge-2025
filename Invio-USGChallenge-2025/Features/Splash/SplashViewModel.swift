//
//  SplashViewModel.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/7/25.
//

import Foundation
import Combine

final class SplashViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published private(set) var viewState: ViewState = .showData
    @Published private(set) var cityLocations: [City] = []
    
    // MARK: - Dependencies
    private let networkManager: NetworkService
    private let cacheManager: CacheService
    private let imageDownloadManager: ImageDownloadService
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private var currentFetchTask: Task<Void, Never>?
    private var currentImageDownloadTask: Task<Data?, Never>?
    
    // MARK: - Initialization
    init(
        networkManager: NetworkService,
        cacheManager: CacheService,
        imageDownloadManager: ImageDownloadService
    ) {
        self.networkManager = networkManager
        self.cacheManager = cacheManager
        self.imageDownloadManager = imageDownloadManager
    }
    
    private func cancelCurrentTask() {
        currentFetchTask?.cancel()
        currentFetchTask = nil
    }
    
    private func cancelImageTask() {
        currentImageDownloadTask?.cancel()
        currentImageDownloadTask = nil
    }
    
    deinit {
        cancelCurrentTask()
        cancelImageTask()
    }
}

// MARK: - Network Request Methods
extension SplashViewModel {
    func fetchInitialCityData() {
        cancelCurrentTask()
        
        currentFetchTask = Task { [weak self] in
            guard let self = self else { return }
            
            await MainActor.run {
                self.viewState = .loading
            }
            
            do {
                try Task.checkCancellation()
                
                let cityResponse: CityResponse = try await networkManager.fetch(
                    with: CityLocationEndpoint.getCityLocations(page: 1))
                print("Data çekildi")
                
                await MainActor.run {
                    print("🏁 MainActor içinde")
                    self.cityLocations = cityResponse.data
                    self.viewState = .showData
                    print("🎯 ViewState güncellendi: \(self.viewState)")
                }
  
            } catch {
                print("🧨 Hata yakalandı: \(error)")
                if let networkError = error as? NetworkError {
                    await MainActor.run {
                        self.viewState = .error(networkError.errorDescription)
                    }
                } else {
                    await MainActor.run {
                        self.viewState = .error("Beklenmeyen hata oluştu.")
                    }
                }
            }
        }
    }
    
    private func cacheCityData(_ cities: [City]) async {
        cacheManager.setCityData(cities)
    }
    
    private func cacheLocationImages(from cities: [City]) async {
        for city in cities {
            for location in city.locations {
                if let imageUrlString = location.image, !imageUrlString.isEmpty {
                    await downloadAndCacheImage(for: imageUrlString)
                }
            }
        }
    }
}

// MARK: - Image Cache Methods
extension SplashViewModel {
    private func downloadAndCacheImage(for urlString: String) async {
        // Skip if image is already cached
        if retrieveImageFromCache(urlString) != nil {
            return
        }
        
        do {
            if let imageData = try await imageDownloadManager.downloadImage(urlString) {
                cacheImage(imageData, for: urlString)
            }
        } catch {
            print("Image download error: \(error.localizedDescription)")
        }
    }
    
    private func cacheImage(_ imageData: Data, for urlString: String) {
        do {
            try cacheManager.setImageCache(url: urlString.asNSString, data: imageData)
        } catch {
            print("Cache error: \(error.localizedDescription)")
        }
    }
    
    private func retrieveImageFromCache(_ urlString: String) -> Data? {
        do {
            return try cacheManager.retrieveImageFromCache(with: urlString.asNSString)
        } catch {
            print("Cache retrieval error: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func cacheCityData(_ cities: [City]) {
        do {
            cacheManager.setCityData(cities)
        } catch {
            print("City data cache error: \(error.localizedDescription)")
        }
    }
}

extension SplashViewModel {
    var canNavigateToHome: Bool {
        return viewState == .showData
    }
}
