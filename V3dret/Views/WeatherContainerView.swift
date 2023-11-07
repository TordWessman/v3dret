//
//  WeatherDetailsView.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-06.
//

import SwiftUI

struct WeatherContainerView: View {

    @ObservedObject var viewModel: WeatherContainerViewModel
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle:
                Spacer()
            case .loading:
                Spacer()
                ProgressView()
                Spacer()
            case .error(let viewModel):
                ErrorView(viewModel: viewModel)
            case .ready(let detailsViewModel):
                WeatherDetailsView(viewModel: detailsViewModel)
            }
        }.onAppear {
            viewModel.load()
        }
    }
}
