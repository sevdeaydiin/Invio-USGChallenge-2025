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
    @Published var shouldCenterOnUser: Bool = false
    @Published var shouldCenterOnUserLocationAfterPermission: Bool = false
    
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
        // When the app is opened for the first time and location permission has not yet been requested
        let hasRequestedPermission = UserDefaults.hasRequestedLocationPermission
        if !hasRequestedPermission && locationManager.authorizationStatus == .notDetermined {
            showLocationPermissionAlert = true
        } 
        // If location permission is granted
        else if locationManager.authorizationStatus == .authorizedWhenInUse ||
                locationManager.authorizationStatus == .authorizedAlways {
            updateUserLocation()
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
                if self.shouldCenterOnUserLocationAfterPermission {
                    self.shouldCenterOnUser = true
                    self.shouldCenterOnUserLocationAfterPermission = false
                }
            }
            .store(in: &cancellables)
        
        locationManager.$shouldShowSettingsAlert
            .sink { [weak self] shouldShow in
                self?.shouldShowSettingsAlert = shouldShow
            }
            .store(in: &cancellables)
        
        locationManager.$authorizationStatus
            .sink { [weak self] status in
                guard let self = self else { return }
                
                switch status {
                case .authorizedWhenInUse, .authorizedAlways:
                    self.locationManager.fetchUserLocation()
                    if self.shouldCenterOnUserLocationAfterPermission {
                        self.shouldCenterOnUser = true
                    }
                case .denied, .restricted:
                    // Settings guide alert
                    break
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Location button actions
    func handleLocationButtonTap() {
        centerOnUserLocation()
    }
    
    func centerOnUserLocation() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            shouldCenterOnUserLocationAfterPermission = true
            showLocationPermissionAlert = true
        case .authorizedAlways, .authorizedWhenInUse:
            shouldCenterOnUser = true
            locationManager.fetchUserLocation()
        case .denied, .restricted:
            shouldShowSettingsAlert = true
        @unknown default:
            break
        }
    }
    
    func handleLocationPermissionResponse(isAccepted: Bool) {
        if isAccepted {
            locationManager.requestLocationAccess()
            shouldCenterOnUserLocationAfterPermission = true
        }
        
        // Save permission requested
        UserDefaults.hasRequestedLocationPermission = true
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func updateUserLocation() {
        locationManager.fetchUserLocation()
    }
    
    func selectLocation(_ locationId: Int) {
        selectedLocationId = locationId
    }
    
    // Getter that returns location permission status
    var authorizationStatus: CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
}

