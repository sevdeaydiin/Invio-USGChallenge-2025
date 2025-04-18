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
    
    init(location: Location) {
        self.location = location
        _ = CLLocationCoordinate2D(latitude: location.coordinates.lat, longitude: location.coordinates.lng)
        
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: location.coordinates.lat, longitude: location.coordinates.lng),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        )
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
                MapAnnotation(coordinate: annotation.coordinates) {
                    if annotation.isUserLocation {
                        // Kullanıcı konumu için icon
                        Image(systemName: "scope")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .shadow(radius: 4)
                            .padding(3)
                            .background(Circle().fill(Color.white).shadow(radius: 4))
                    } else {
                        // Seçilen konum için icon (mevcut star.fill)
                        Image(systemName: "mappin.and.ellipse")
                            .font(.headline)
                            .foregroundColor(.purple)
                            .shadow(radius: 4)
                            .padding(3)
                            .background(Circle().fill(Color.white).shadow(radius: 4))
                    }
                }
            }
            .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        // Location icon (left-bottom)
                        LocationIcon(action: viewModel.centerOnUserLocation)
                    }
                    
                    // Directions Button
                    CustomButton(buttonText: "Yol Tarifi Al") {
                        
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
            .toolbar {
                ToolbarItemView(location: location.name)
            }
        }
        .onReceive(viewModel.$userLocation) { userCoordinate in
            if viewModel.shouldCenterOnUser, let userLocation = viewModel.userLocation {
                region = MKCoordinateRegion(
                    center: userCoordinate ?? CLLocationCoordinate2D(latitude: location.coordinates.lat, longitude: location.coordinates.lng),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                annotations = [
                    CustomAnnotation(coordinates: CLLocationCoordinate2D(latitude: location.coordinates.lat, longitude: location.coordinates.lng), isUserLocation: false),
                    CustomAnnotation(coordinates: userCoordinate ?? CLLocationCoordinate2D(latitude: location.coordinates.lat, longitude: location.coordinates.lng), isUserLocation: true)
                ]
                
                DispatchQueue.main.async {
                    viewModel.shouldCenterOnUser = false
                }
            }
        }
        .onAppear {
            annotations = [CustomAnnotation(coordinates: CLLocationCoordinate2D(
                    latitude: location.coordinates.lat,
                    longitude: location.coordinates.lng
                ), isUserLocation: false)]
            viewModel.requestLocationAccess()
        }
        .alert(isPresented: $viewModel.shouldShowSettingsAlert) {
            Alert(title: Text("Konum izni gerekli"),
                  message: Text("Lütfen Ayarlar'dan konum erişimine izin verin."),
                  primaryButton: .default(Text("Aç"), action: {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }),
                  secondaryButton: .cancel(Text("İptal")))
        }
    }
}

struct CustomAnnotation: Identifiable {
    let id = UUID()
    let coordinates: CLLocationCoordinate2D
    let isUserLocation: Bool
}

private struct LocationIcon: View {
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Circle()
                .fill(Color.white)
                .frame(width: 50, height: 50)
                .overlay(
                    Image("location")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding()
                )
                .background(
                    Circle()
                        .stroke(.black)
                )
                .padding(.bottom, 20)
        }
    }
}

private struct ToolbarItemView: ToolbarContent {
    @Environment(\.dismiss) var dismiss
    let location: String
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
        }
        
        ToolbarItem(placement: .principal) {
            Text(location)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
    }
}
