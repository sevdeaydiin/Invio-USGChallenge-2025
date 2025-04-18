//
//  CityMapViewModel.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/18/25.
//

import Foundation
import MapKit

class CityMapViewModel: ObservableObject {
    @Published var cityName: String
    @Published var locations: [Location]
    
    init(cityName: String, locations: [Location]) {
        self.cityName = cityName
        self.locations = locations
    }
}
