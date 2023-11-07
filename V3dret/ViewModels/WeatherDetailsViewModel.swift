//
//  WeatherDetailsViewModel.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-06.
//

import SwiftUI

class WeatherDetailsViewModel: ObservableObject {

    static let imageBaseEndpoint = V3dretConfiguration.shared.imageEndpoint

    @Published private(set) var title: String
    @Published private(set) var temperature: String
    @Published private(set) var url: URL?
    @Published private(set) var description: String
    @Published private(set) var windArrowView: AnyView?
    @Published private(set) var windSpeed: String?

    init(title: String, _ weatherResponse: WeatherResponse) {
        self.title = title
        self.temperature = "temperature_text".localize(weatherResponse.main?.temp ?? 0)
        if let icon = weatherResponse.weather.first?.icon,
           let url = URL(string: "\(Self.imageBaseEndpoint)\(icon)@2x.png") {
            self.url = url
        } else {
            url = nil // TODO: placeholder
        }

        description = weatherResponse.weather.first?.description?.capitalized ?? ""

        if let speed = weatherResponse.wind?.speed, let angle = weatherResponse.wind?.deg {
            windArrowView = AnyView(Image(systemName: "paperplane")
                                .rotationEffect(Angle(degrees: 45.0 - angle)))
            windSpeed = "wind_speed_text".localize(speed)
        }
    }
}
