//
//  Modelz.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-02.
//

import Foundation

struct GeoLookupRequest: RequestModel {

    typealias ResponseType = [GeoLookupItem]
    let q: String
    let limit = 10
    func path() -> String { "geo/1.0/direct" }
    func ttl() -> TimeInterval { 60 * 60 * 24 }
}

struct GeoLookupItem: Decodable {

    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
