//
//  WeatherContainerViewModel.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-06.
//

import UIKit

extension WeatherResponse {

    var containsEnoughData: Bool {
        return main?.temp != nil && !desription.isEmpty
    }
}

@MainActor
class WeatherContainerViewModel: ObservableObject {

    enum State {
        case idle
        case loading
        case error(_ viewModel: ErrorViewModel)
        case ready(_ details: WeatherDetailsViewModel)
    }

    @Published private(set) var state: State = .idle

    private let client: WebClient
    private let lon: Double
    private let lat: Double
    private let lang: String
    private let title: String

    init(title: String, lon: Double, lat: Double, lang: String, client: WebClient) {
        self.client = client
        self.lon = lon
        self.lat = lat
        self.lang = lang
        self.title = title
    }

    func load() {
        state = .loading
        Task { [weak self] in
            guard let self else { return }
            do {
                let weatherResponse = try await client.send(request: WeatherRequest(lon: lon, lat: lat, lang: lang))
                guard weatherResponse.containsEnoughData else {
                    return self.state = .error(ErrorViewModel(message: "error_not_enough_data_text".localized, reload: nil))
                }
                self.state = .ready(WeatherDetailsViewModel(title: self.title, weatherResponse))
            } catch {
                self.state = .error(ErrorViewModel(message: error.localizedDescription, reload: { [weak self] in
                    self?.load()
                }))
            }
        }
    }
}
