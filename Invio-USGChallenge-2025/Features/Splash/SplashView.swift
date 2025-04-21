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
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.white
                        .ignoresSafeArea()

                    VStack(spacing: 16) {
                        Spacer()

                        LottieView(animationName: "location")
                            .frame(
                                maxWidth: geometry.size.width * 0.7,
                                maxHeight: geometry.size.height * 0.5
                            )
                            .scaleEffect(isAnimating ? 1 : 0.8)
                            .animation(.easeInOut(duration: 1), value: isAnimating)

                        Text("Şehirdeki Önemli Konumlar")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.black)
                            //.padding(.horizontal)
                        
                        contentView
                            .frame(maxWidth: .infinity)

                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .padding()
                }
            }
//            .onChange(of: viewModel.canNavigateToHome) { _, newValue in
//                if newValue {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        navigateToHome = true
//                    }
//                }
//            }
//            .onAppear {
//                isAnimating = true
//                viewModel.fetchInitialCityData()
//            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(1.5)
                .tint(.blue)
                .padding(.top)

        case .noData:
            Text("Veri bulunamadı.")
                .font(.title3)
                .foregroundStyle(.red)

        case .showData:
            EmptyView()

        case .error(let error):
            VStack(spacing: 12) {
                Text("Bir hata oluştu!")
                    .font(.title3)
                    .foregroundStyle(.red)

                Text(error)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button("Tekrar Dene") {
                    viewModel.fetchInitialCityData()
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.top)
        }
    }
}


#Preview {
    SplashView(viewModel: SplashViewModel(networkManager: NetworkManager(), cacheManager: CacheManager(), imageDownloadManager: ImageDownloadManager()))
}
