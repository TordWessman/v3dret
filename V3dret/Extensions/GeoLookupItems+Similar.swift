//
//  GeoLookupItem+Similar.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-06.
//

import Foundation

extension Array where Element == GeoLookupItem {

    private static let delimiter: Double = 0.2

    func removeSimilar() -> [Element] {

        var items = [GeoLookupItem]()
        for i in self {
            if !items.contains(where: {
                (i.name.contains($0.name) || $0.name.contains(i.name))  &&
                $0.country == i.country &&
                abs($0.lon - i.lon) < Self.delimiter &&
                abs($0.lat - i.lat) < Self.delimiter
            }) {
                items.append(i)
            }
        }
        return items
    }
}
