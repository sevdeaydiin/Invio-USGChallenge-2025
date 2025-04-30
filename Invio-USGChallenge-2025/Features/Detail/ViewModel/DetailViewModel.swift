import Foundation
import SwiftUI

final class DetailViewModel: ObservableObject {
    // MARK: - Properties
    let location: Location
    private let favoriteManager = FavoriteManager.shared
    
    // MARK: - Published Properties
    @Published private(set) var isFavorite: Bool
    
    // MARK: - Initialization
    init(location: Location) {
        self.location = location
        self.isFavorite = favoriteManager.isFavorite(location.id)
    }
    
    // MARK: - Computed Properties
    var name: String {
        location.name
    }
    
    var description: String {
        location.description
    }
    
    var imageUrl: String? {
        location.image
    }
    
    // MARK: - Favorite Method
    func toggleFavorite() {
        if isFavorite {
            favoriteManager.removeFromFavorite(location.id)
        } else {
            favoriteManager.addToFavorite(location.id)
        }
        isFavorite.toggle()
        NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
    }
} 
