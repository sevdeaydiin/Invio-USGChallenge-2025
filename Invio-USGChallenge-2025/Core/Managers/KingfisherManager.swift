//
//  KingfisherMAnager.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/10/25.
//

import Kingfisher

extension KingfisherManager {
    static func shared() -> KingfisherManager {
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024 // 300MB
        cache.diskStorage.config.sizeLimit = 1000 * 1024 * 1024 // 1GB
        
        return KingfisherManager.shared
    }
}

extension KFImage {
    func setupCache() -> KFImage {
        return self
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .resizable()
            .onSuccess { result in
                // Save cache
                if let imageData = result.image.pngData() {
                    do {
                        try CacheManager.shared.setImageCache(
                            url: result.source.url?.absoluteString.asNSString ?? "",
                            data: imageData
                        )
                    } catch {
                        print("Cache error: \(error.localizedDescription)")
                    }
                }
            }
            .onFailure { error in
                print("Image loading error: \(error.localizedDescription)")
            }
    }
}
