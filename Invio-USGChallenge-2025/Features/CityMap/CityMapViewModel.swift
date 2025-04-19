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
    
    // MARK: - Handle location button behavior based on current permission state
    func handleLocationButtonTap() -> Bool {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            updateUserLocation()
            return true
        case .notDetermined:
            locationManager.requestLocationAccess()
            return false
        case .denied, .restricted:
            locationManager.shouldShowSettingsAlert = true
            return false
        @unknown default:
            return false
        }
    }
    
    // MARK: - Fetch current user location if authorized
    func updateUserLocation() {
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            locationManager.fetchUserLocation()
        }
    }
    
    // MARK: - Ask for location permission
    func requestLocationPermission() {
        locationManager.requestLocationAccess()
    }

    // MARK: - Open app settings if permission is denied
    func openSettings() {
        locationManager.openSettings()
    }
    
    // MARK: - Bind location updates from LocationManager to the ViewModel
    private func bindLocationUpdates() {
        locationManager.$userLocation
            .assign(to: &$userLocation)
        locationManager.$shouldShowSettingsAlert
            .assign(to: &$shouldShowSettingsAlert)
    }
}

