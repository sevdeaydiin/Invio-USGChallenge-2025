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
    
    var body: some View {
        VStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: viewModel.locations.first?.coordinates.lat ?? 0,
                                               longitude: viewModel.locations.first?.coordinates.lng ?? 0),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )), annotationItems: viewModel.locations) { location in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.coordinates.lat, longitude: location.coordinates.lng),
                          tint: .blue)
            }
            .edgesIgnoringSafeArea(.all)
            .navigationTitle(viewModel.cityName)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(viewModel.locations) { location in
                        VStack {
                            if let imageUrl = location.image, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                            }
                            Text(location.name)
                                .font(.headline)
                            Button("Detaya Git") {
                                // Navigate to detail view
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    CityMapView(viewModel: CityMapViewModel(cityName: "Ankara", locations: CityResponse.mockData.data.first?.locations ?? []))
}
