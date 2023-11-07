//
//  WeatherRequest.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-02.
//

import Foundation

struct WeatherRequest: RequestModel {

    typealias ResponseType = WeatherResponse

    let lon: Double
    let lat: Double
    let lang: String
    let units = "metric"

    //https://openweathermap.org/current
    func path() -> String { "data/2.5/weather" }
}

struct WeatherResponse: Decodable {

    struct Details: Decodable {

        let temp: Double?
        let humidity: Double?
    }

    struct Wind: Decodable {
        let speed: Double?
        let deg: Double?
    }

    struct Description : Decodable {

        let description: String?
        let icon: String?
    }

    let weather: [Description]
    let main: Details?
    let wind: Wind?
    
    var desription: String { return weather.first?.description ?? "" }
}
