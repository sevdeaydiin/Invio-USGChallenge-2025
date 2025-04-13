//
//  ImageDowloadManager.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/6/25.
//

import Foundation
import UIKit

protocol ImageDownloadService: AnyObject {
    func downloadImage(_ url: String) async throws -> Data?
}

final class ImageDownloadManager: ImageDownloadService {
    private let session: URLSession
    
    init(sessions: URLSession = .shared) {
        self.session = sessions
    }
    
    func downloadImage(_ url: String) async throws -> Data? {
        guard let url = URL(string: url), await UIApplication.shared.canOpenURL(url) else {
            throw NetworkError.invalidURL
        }
        
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        return data
    }
}
