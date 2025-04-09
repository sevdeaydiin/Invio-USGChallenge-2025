//
//  SplashView.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/7/25.
//

import SwiftUI

struct SplashView: View {
    @StateObject var viewModel: SplashViewModel
    @State private var isAnimating = false
    @State private var navigateToHome = false
    
    init(viewModel: SplashViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    Text("Şehirdeki Önemli Konumlar")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                   
                    contentView
                }
            }
            .onChange(of: viewModel.canNavigateToHome) { canNavigate in
                if canNavigate {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        navigateToHome = true
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                isAnimating = true
            }
            viewModel.fetchInitialCityData()
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
                .tint(.blue)
            
        case .noData:
            Text("No data")
                .font(.title2)
                .foregroundStyle(.red)
            
        case .showData:
            NavigationLink(
                destination: HomeView()
                    .navigationBarBackButtonHidden(true),
                isActive: $navigateToHome) {
                EmptyView()
            }
            
        case .error(let error):
            VStack(spacing: 16) {
                Text("Error!")
                    .font(.title2)
                    .foregroundColor(.red)
                
                Text(error)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button("Tekrar Dene") {
                    viewModel.fetchInitialCityData()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(.blue)
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    SplashView(viewModel: SplashViewModel(networkManager: NetworkManager(), cacheManager: CacheManager(), imageDownloadManager: ImageDownloadManager()))
}
