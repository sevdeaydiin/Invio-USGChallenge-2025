//
//  LocationManager.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/16/25.
//

import Foundation
import CoreLocation
import Combine
import UIKit

class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var shouldShowSettingsAlert: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Request location access permission or direct user to settings
    func requestLocationAccess() {
        if authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if authorizationStatus == .denied || authorizationStatus == .restricted {
            shouldShowSettingsAlert = true
        }
    }
    
    // Start getting location information
    func fetchUserLocation() {
        manager.startUpdatingLocation()
    }
    
    // Redirect user to application settings
    func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsUrl) else { return }
        UIApplication.shared.open(settingsUrl)
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    // Called when authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
        }

        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            shouldShowSettingsAlert = true
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    // Called when a new location information is received
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        DispatchQueue.main.async {
            self.userLocation = coordinate
        }
        // Stop to prevent unnecessary battery consumption
        manager.stopUpdatingLocation()
    }
}
