//
//  LocationMapViewModel.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/13/25.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI
import UIKit
import Combine

class LocationMapViewModel: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var shouldCenterOnUser: Bool = false
    @Published var shouldShowSettingsAlert: Bool = false
    @Published var shouldShowLocationPermissionAlert: Bool = false
    @Published var shouldCenterOnUserLocationAfterPermission: Bool = false
    @Published var isFirstLocationRequest: Bool = true
    
    private var locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    override init() {
        self.locationManager = .shared
        super.init()
        bindLocationUpdates()
    }
    
    private func bindLocationUpdates() {
        locationManager.$userLocation
            .sink { [weak self] location in
                guard let self = self, let location = location else { return }
                self.userLocation = location
                if self.shouldCenterOnUserLocationAfterPermission {
                    self.shouldCenterOnUser = true
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
                    if !self.isFirstLocationRequest {
                        self.shouldShowSettingsAlert = true
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    // Ask the user for location access when the app is in use
    func requestLocationAccess() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            if isFirstLocationRequest {
                shouldShowLocationPermissionAlert = true
            } else {
                locationManager.requestLocationAccess()
            }
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.fetchUserLocation()
            if shouldCenterOnUserLocationAfterPermission {
                shouldCenterOnUser = true
            }
        case .denied, .restricted:
            if !isFirstLocationRequest {
                shouldShowSettingsAlert = true
            }
        @unknown default:
            break
        }
    }
    
    func centerOnUserLocation() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            if isFirstLocationRequest {
                shouldCenterOnUserLocationAfterPermission = true
                shouldShowLocationPermissionAlert = true
                isFirstLocationRequest = false
            } else {
                locationManager.requestLocationAccess()
            }
        case .authorizedAlways, .authorizedWhenInUse:
            shouldCenterOnUser = true
            locationManager.fetchUserLocation()
        case .denied, .restricted:
            shouldShowSettingsAlert = true
        @unknown default:
            break
        }
    }
    
    // Start fetching the user's location
    func fetchUserLocation() {
        locationManager.fetchUserLocation()
    }
    
    func handleLocationPermissionResponse(isAccepted: Bool) {
        if isAccepted {
            locationManager.requestLocationAccess()
        } else {
            shouldCenterOnUserLocationAfterPermission = false
        }
        isFirstLocationRequest = false
    }
    
    func openDirections(for location: Location) {
        guard let userLocation = userLocation else {
            return
        }
        
        let destinationLat = location.coordinates.lat
        let destinationLng = location.coordinates.lng
        
        let alert = UIAlertController(
            title: "Harita Seçin",
            message: "Hangi harita uygulamasını kullanmak istersiniz?",
            preferredStyle: .actionSheet
        )
        
        let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel)
        alert.addAction(cancelAction)
        
        // Google Maps
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            let googleMapsAction = UIAlertAction(title: "Google", style: .default) { _ in
                let urlString = "comgooglemaps://?saddr=\(userLocation.latitude),\(userLocation.longitude)&daddr=\(destinationLat),\(destinationLng)&directionsmode=driving"
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            alert.addAction(googleMapsAction)
        }
        
        // Apple Maps
        let appleMapsAction = UIAlertAction(title: "Haritalar", style: .default) { _ in
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLng)))
            destination.name = location.name
            
            let currentLocation = MKMapItem.forCurrentLocation()
            
            MKMapItem.openMaps(
                with: [currentLocation, destination],
                launchOptions: [
                    MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
                ]
            )
        }
        alert.addAction(appleMapsAction)
        
        // Yandex Maps
        if UIApplication.shared.canOpenURL(URL(string: "yandexmaps://")!) {
            let yandexMapsAction = UIAlertAction(title: "Yandex Haritalar", style: .default) { _ in
                let urlString = "yandexmaps://build_route_on_map?lat_from=\(userLocation.latitude)&lon_from=\(userLocation.longitude)&lat_to=\(destinationLat)&lon_to=\(destinationLng)"
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            alert.addAction(yandexMapsAction)
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(alert, animated: true)
        }
    }
}
