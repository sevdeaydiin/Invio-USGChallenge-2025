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

class LocationMapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: - Published Properties
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var shouldCenterOnUser: Bool = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var shouldShowSettingsAlert: Bool = false
    
    private let manager = CLLocationManager()
    
    // MARK: - Initialization
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Ask the user for location access when the app is in use
    func requestLocationAccess() {
        manager.requestWhenInUseAuthorization()
    }
    
    func centerOnUserLocation() {
        let status = manager.authorizationStatus
        
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            fetchUserLocation()
        case .denied, .restricted:
            shouldShowSettingsAlert = true
        @unknown default:
            break
        }
    }
    
    // Start fetching the user's location
    func fetchUserLocation() {
        manager.startUpdatingLocation()
    }

    // Called when the user's location permission status changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let status = manager.authorizationStatus
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            fetchUserLocation()
        }
    }
    
    // Called when new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            DispatchQueue.main.async {
                self.userLocation = coordinate
                self.shouldCenterOnUser = true
            }
            manager.stopUpdatingLocation()
        }
    }
}
