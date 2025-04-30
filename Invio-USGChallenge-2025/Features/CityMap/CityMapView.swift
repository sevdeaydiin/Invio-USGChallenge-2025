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
            MapViewContent(
                region: $mapRegion,
                viewModel: viewModel
            )
            .ignoresSafeArea(.all)
            .onAppear {
                setupInitialRegion()
                viewModel.onAppear()
            }
            
            VStack(alignment: .trailing) {
                LocationButtonView(viewModel: viewModel, mapRegion: $mapRegion)
                LocationCardsView(viewModel: viewModel, mapRegion: $mapRegion)
            }
        }
        .onReceive(viewModel.$userLocation) { userCoordinate in
            guard let userCoordinate = userCoordinate, viewModel.shouldCenterOnUser else { return }
            
            mapRegion = MKCoordinateRegion(
                center: userCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            
            DispatchQueue.main.async {
                viewModel.shouldCenterOnUser = false
            }
        }
        .alert("Kendi konumunu haritada görmek ister misin?", isPresented: $viewModel.showLocationPermissionAlert) {
            Button("Evet") {
                viewModel.handleLocationPermissionResponse(isAccepted: true)
            }
            Button("Hayır", role: .cancel) {
                viewModel.handleLocationPermissionResponse(isAccepted: false)
            }
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
    
    private func setupInitialRegion() {
        guard let firstLocation = viewModel.locations.first else { return }
        mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: firstLocation.coordinates.lat,
                longitude: firstLocation.coordinates.lng
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
}

private struct MapViewContent: View {
    @Binding var region: MKCoordinateRegion
    let viewModel: CityMapViewModel
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: annotationItems) { location in
            MapAnnotation(coordinate: location.coordinate) {
                LocationAnnotationView(location: location, selectedId: viewModel.selectedLocationId)
            }
        }
    }
    
    private var annotationItems: [MapLocation] {
        var items = viewModel.locations.map { location in
            MapLocation(
                id: location.id,
                name: location.name,
                coordinate: CLLocationCoordinate2D(
                    latitude: location.coordinates.lat,
                    longitude: location.coordinates.lng
                ),
                type: .location
            )
        }
        
        if let userLocation = viewModel.userLocation {
            items.append(
                MapLocation(
                    id: -1,
                    name: "Kullanıcı Konumu",
                    coordinate: userLocation,
                    type: .user
                )
            )
        }
        
        return items
    }
}

private struct LocationAnnotationView: View {
    let location: MapLocation
    let selectedId: Int?
    
    var body: some View {
        Group {
            switch location.type {
            case .user:
                Image(systemName: "circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.violetBlue)
                    .shadow(radius: 4)
                    .padding(3)
                    .background(Circle().fill(Color.white).shadow(radius: 5))
            case .location:
                if location.id == selectedId {
                    Image("star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                } else {
                    Image("location")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                }
            }
        }
    }
}

private struct ToolbarItemView: ToolbarContent {
    @Environment(\.dismiss) var dismiss
    let cityName: String
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Image(systemName: "chevron.left")
                .foregroundColor(.primary)
                .fontWeight(.bold)
                .onTapGesture {
                    dismiss()
                }
        }
        
        ToolbarItem(placement: .principal) {
            Text(cityName)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
}

private struct MapLocation: Identifiable {
    let id: Int
    let name: String
    let coordinate: CLLocationCoordinate2D
    let type: LocationType
    
    enum LocationType {
        case user
        case location
    }
}
