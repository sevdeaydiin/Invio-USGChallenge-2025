//
//  CacheManager.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/6/25.
//

import Foundation

protocol CacheService {
    func setImageCache(url: NSString, data: Data) throws
    func retrieveImageFromCache(with url: NSString) throws -> Data?
    func setCityData(_ cities: [City])
    func getCityData() -> [City]?
    func clearAllCache() throws
}

final class CacheManager: CacheService {
    
    // In memory image cache using NSCache
    private let cache = NSCache<NSString, NSData>()
    
    // Shared instance for global access
    static let shared = CacheManager()
    
    // MARK: - Caches image data in memory using a URL as the key
    func setImageCache(url: NSString, data: Data) throws {
        cache.setObject(data as NSData, forKey: url)
    }
    
    // MARK: - Retrieves cached image data from memory
    func retrieveImageFromCache(with url: NSString) throws -> Data? {
        return cache.object(forKey: url) as? Data
    }
    
    // MARK: - Stores city data into UserDefaults after encoding
    func setCityData(_ cities: [City]) {
        if let _ = try? JSONEncoder().encode(cities) {
            UserDefaults.cachedCityData = cities
        }
    }
    
    // MARK: - Retrieves city data from UserDefaults
    func getCityData() -> [City]? {
        let data = UserDefaults.cachedCityData
        return data.isEmpty ? nil : data
    }
    
    // MARK: - Clears both in memory and persistent cache
    func clearAllCache() throws {
        cache.removeAllObjects()
        UserDefaults.cachedCityData = []
    }
}
