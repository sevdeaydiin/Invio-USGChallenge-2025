//
//  CityMapView.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/18/25.
//

import SwiftUI
import MapKit

struct CityMapView: View {
    @ObservedObject var viewModel: CityMapViewModel
    @State private var mapRegion: MKCoordinateRegion
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: CityMapViewModel, mapRegion: MKCoordinateRegion? = nil) {
        self.viewModel = viewModel
        if let region = mapRegion {
            self._mapRegion = State(initialValue: region)
        } else {
            self._mapRegion = State(initialValue: MKCoordinateRegion())
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $mapRegion, annotationItems: viewModel.locations + [Location(id: -1, name: "Kullanıcı Konumu", description: "", coordinates: Coordinates(lat: viewModel.userLocation?.latitude ?? 0, lng: viewModel.userLocation?.longitude ?? 0), image: nil)]) { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.coordinates.lat, longitude: location.coordinates.lng)) {
                    if location.id == -1 {
                        if viewModel.userLocation != nil {
                            // User location icon
                            Image(systemName: "circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.violetBlue)
                                .shadow(radius: 4)
                                .padding(3)
                                .background(Circle().fill(Color.white).shadow(radius: 5))
                                
                        }
                    } else {
                        // City locations icon
                        Image(systemName: "mappin.circle.fill")
                            .foregroundStyle(.red)
                            .font(.title2)
                    }
                }
            }
            .ignoresSafeArea(.all)
            
            .onAppear { // Set initial map region to first location
                mapRegion = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: viewModel.locations.first?.coordinates.lat ?? 0,
                                                   longitude: viewModel.locations.first?.coordinates.lng ?? 0),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                viewModel.onAppear()
            }
            
            VStack(alignment: .trailing) {
                // Current location
                LocationButton {
                    Task { @MainActor in
                        if viewModel.handleLocationButtonTap() {
                            if let userLocation = viewModel.userLocation {
                                mapRegion.center = userLocation
                                mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            }
                        }
                    }
                }
                
                // Location cards
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.locations) { location in
                            HorizontalLocationCard(location: location)
                        }
                    }.padding()
                }
            }
        }
        .alert("Konum İzni", isPresented: $viewModel.showLocationPermissionAlert) {
            Button("Evet") {
                viewModel.requestLocationPermission()
            }
            Button("Hayır", role: .cancel) { }
        } message: {
            Text("Kendi konumunu haritada görmek ister misin?")
        }
        .alert("Konum İzni Gerekli", isPresented: $viewModel.shouldShowSettingsAlert) {
            Button("Ayarlara Git") {
                viewModel.openSettings()
            }
            Button("İptal", role: .cancel) { }
        } message: {
            Text("Konumunuzu görebilmek için ayarlardan konum iznini etkinleştirmeniz gerekmektedir.")
        }
        .toolbar {
            ToolbarItemView(cityName: viewModel.cityName)
        }
    }
}

private struct ToolbarItemView: ToolbarContent {
    @Environment(\.dismiss) var dismiss
    let cityName: String
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .fontWeight(.bold)
                .onTapGesture {
                    dismiss()
                }
        }
        
        ToolbarItem(placement: .principal) {
            Text(cityName)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
    }
}
