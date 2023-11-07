//
//  LocationItemViewModel.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-02.
//

import Foundation

@MainActor
class LocationItemViewModel: Identifiable {

    let detailsViewModel: WeatherContainerViewModel
    let title: String
    let flagEmoji: String
    let lang: String
    let lon: Double
    let lat: Double

    init(title: String, flagEmoji: String, lon: Double, lat: Double, lang: String, client: WebClient) {
        self.title = title
        self.flagEmoji = flagEmoji
        self.lon = lon
        self.lat = lat
        self.lang = lang
        self.detailsViewModel = WeatherContainerViewModel(title: title, lon: lon, lat: lat, lang: lang, client: client)
    }
}
