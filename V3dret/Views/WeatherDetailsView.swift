//
//  WeatherDetailsView.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-02.
//

import SwiftUI

struct WeatherDetailsView: View {

    @ObservedObject var viewModel: WeatherDetailsViewModel

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    AsyncImage(url: viewModel.url) { image in
                        image
                            .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
                    } placeholder: {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .padding(EdgeInsets(top: 75, leading: 0, bottom: 0, trailing: 50))
                    }
                }
                Spacer()
            }

            HStack {
                VStack {
                    Text(viewModel.title)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(viewModel.temperature)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                    Text(viewModel.description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 6, trailing: 0))
                    if let windArrow = viewModel.windArrowView, let windSpeed = viewModel.windSpeed {
                        HStack {
                            Text(windSpeed)
                            windArrow
                            Spacer()
                        }
                    }
                    Spacer()
                }.padding()
                Spacer()
            }


        }

    }
}
