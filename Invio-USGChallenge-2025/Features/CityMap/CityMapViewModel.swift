//
//  CityMapViewModel.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/18/25.
//

import Foundation
import MapKit
import CoreLocation
import Combine

class CityMapViewModel: NSObject, ObservableObject {
    // MARK: - Published properties
    @Published var cityName: String
    @Published var locations: [Location]
    @Published var shouldShowSettingsAlert = false
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var showLocationPermissionAlert = false
    @Published var selectedLocationId: Int?
    @Published var locationDistances: [Int: String] = [:]
    
    private var locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    init(
        cityName: String,
        locations: [Location],
        locationManager: LocationManager = .shared
    ) {
        self.cityName = cityName
        self.locations = locations
        self.locationManager = locationManager
        super.init()
        bindLocationUpdates()
        self.selectedLocationId = locations.first?.id
    }
    
    // MARK: - Handle location permission state
    func onAppear() {
        if locationManager.authorizationStatus == .notDetermined {
            showLocationPermissionAlert = true
        } else if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            updateUserLocation()
        } else if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
            shouldShowSettingsAlert = true
        }
    }
    
    // MARK: - Location related functions
    private func sortLocationsByDistance() {
        guard let userLocation = userLocation else { return }
        
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        locations.sort { loc1, loc2 in
            let loc1Coord = CLLocation(latitude: loc1.coordinates.lat, longitude: loc1.coordinates.lng)
            let loc2Coord = CLLocation(latitude: loc2.coordinates.lat, longitude: loc2.coordinates.lng)
            
            let distance1 = userCLLocation.distance(from: loc1Coord)
            let distance2 = userCLLocation.distance(from: loc2Coord)
            
            locationDistances[loc1.id] = formatDistance(distance1)
            locationDistances[loc2.id] = formatDistance(distance2)
            
            return distance1 < distance2
        }
        
        selectedLocationId = locations.first?.id
    }
    
    private func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance < 1000 {
            return "\(Int(distance))m"
        } else {
            let kilometers = distance / 1000
            return String(format: "%.1fkm", kilometers)
        }
    }
    
    private func bindLocationUpdates() {
        locationManager.$userLocation
            .sink { [weak self] location in
                guard let self = self, let location = location else { return }
                self.userLocation = location
                self.sortLocationsByDistance()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Location button actions
    func handleLocationButtonTap() -> Bool {
        if locationManager.authorizationStatus == .notDetermined {
            showLocationPermissionAlert = true
            return false
        } else if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
            shouldShowSettingsAlert = true
            return false
        }
        locationManager.fetchUserLocation()
        return true
    }
    
    func requestLocationPermission() {
        locationManager.requestLocationAccess()
    }
    
    func openSettings() {
        locationManager.openSettings()
    }
    
    func updateUserLocation() {
        locationManager.fetchUserLocation()
    }
    
    func selectLocation(_ locationId: Int) {
        selectedLocationId = locationId
    }
}

