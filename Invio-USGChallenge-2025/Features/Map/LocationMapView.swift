//
//  LocationMapView.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/13/25.
//

// LocationMapView.swift

import SwiftUI
import MapKit

struct LocationMapView: View {
    let location: Location
    @StateObject private var viewModel = LocationMapViewModel()
    @State private var region: MKCoordinateRegion
    @State private var annotations: [CustomAnnotation] = []
    @Environment(\.dismiss) private var dismiss
    
    init(location: Location) {
        self.location = location
        _ = CLLocationCoordinate2D(latitude: location.coordinates.lat, longitude: location.coordinates.lng)
        
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: location.coordinates.lat, longitude: location.coordinates.lng),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        )
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
                MapAnnotation(coordinate: annotation.coordinates) {
                    if annotation.isUserLocation {
                        // Current location icon
                        Image(systemName: "circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.violetBlue)
                            .shadow(radius: 4)
                            .padding(3)
                            .background(Circle().fill(Color.white).shadow(radius: 4))
                    } else {
                        // Selected location icon
                        Image("location")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                    }
                }
            }
            .ignoresSafeArea(.all)
            
            VStack(alignment: .trailing) {
                // Location icon (left-bottom)
                LocationButton {
                    viewModel.centerOnUserLocation()
                }
                .padding(.bottom)
                
                // Directions Button
                CustomButton(buttonText: "Yol Tarifi Al", height: 50) {
                    viewModel.openDirections(for: location)
                }
                .padding(.horizontal, 30)
            }
            .padding(.bottom)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.primary)
                }
                ToolbarItem(placement: .principal) {
                    Text(location.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
        }
        .onReceive(viewModel.$userLocation) { userCoordinate in
            guard let userCoordinate = userCoordinate, viewModel.shouldCenterOnUser else { return }
            
            region = MKCoordinateRegion(
                center: userCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            
            annotations = [
                CustomAnnotation(coordinates: CLLocationCoordinate2D(latitude: location.coordinates.lat, longitude: location.coordinates.lng), isUserLocation: false),
                CustomAnnotation(coordinates: userCoordinate, isUserLocation: true)
            ]
            
            DispatchQueue.main.async {
                viewModel.shouldCenterOnUser = false
            }
        }
        .onAppear {
            // Show selected location on first load
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: location.coordinates.lat, longitude: location.coordinates.lng),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            
            annotations = [
                CustomAnnotation(coordinates: CLLocationCoordinate2D(latitude: location.coordinates.lat, longitude: location.coordinates.lng), isUserLocation: false)
            ]
            
            // Request user location permission and get location
            viewModel.requestLocationAccess()
        }
        .alert(isPresented: $viewModel.shouldShowSettingsAlert) {
            Alert(title: Text("Konum izni gerekli"),
                  message: Text("Lütfen Ayarlar'dan konum erişimine izin verin."),
                  primaryButton: .default(Text("Aç"), action: {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }),
                  secondaryButton: .cancel(Text("İptal")))
        }
        .alert("Kendi konumunu haritada görmek ister misin?", isPresented: $viewModel.shouldShowLocationPermissionAlert) {
            Button("Evet") {
                viewModel.handleLocationPermissionResponse(isAccepted: true)
            }
            Button("Hayır", role: .cancel) {
                viewModel.handleLocationPermissionResponse(isAccepted: false)
            }
        }
    }
}

private struct CustomAnnotation: Identifiable {
    let id = UUID()
    let coordinates: CLLocationCoordinate2D
    let isUserLocation: Bool
}
