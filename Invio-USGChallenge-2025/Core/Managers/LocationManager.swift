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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.authorizationStatus = manager.authorizationStatus
            
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                self.manager.startUpdatingLocation()
            case .denied, .restricted:
                self.shouldShowSettingsAlert = true
            case .notDetermined:
                break
            @unknown default:
                break
            }
        }
    }
    
    // Called when a new location information is received
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.userLocation = coordinate
            
            // Konum güncellemesi başarılı olduğunda durmak için gecikme ekleyelim
            // bu sayede konum alınması daha güvenilir olacak
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.manager.stopUpdatingLocation()
            }
        }
    }
    
    // Failed to get location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Hata durumunda tekrar deneme
        if let error = error as? CLError {
            switch error.code {
            case .network:
                // Ağ hatası, tekrar dene
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    self?.fetchUserLocation()
                }
            case .denied:
                // Kullanıcı erişimi reddetti
                DispatchQueue.main.async { [weak self] in
                    self?.shouldShowSettingsAlert = true
                }
            default:
                break
            }
        }
    }
}
