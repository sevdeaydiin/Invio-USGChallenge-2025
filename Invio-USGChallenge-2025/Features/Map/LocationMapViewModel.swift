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
            shouldCenterOnUser = true
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
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            fetchUserLocation()
        }
    }
    
    // Called when new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        
        DispatchQueue.main.async {
            self.userLocation = coordinate
        }
        manager.stopUpdatingLocation()
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
