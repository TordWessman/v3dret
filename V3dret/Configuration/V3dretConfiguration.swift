//
//  V3dretConfiguration.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-06.
//

import Foundation

class V3dretConfiguration {

    private init() { }

    static let shared = V3dretConfiguration()

    fileprivate func value<T>(for key: String) -> T where T: CustomStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            fatalError("Key is missing from plist: \(key)")
        }
        guard let value = object as? T else {
            fatalError("Object with key \(key) is of wrong type (\(type(of: object)). Expected '\(T.self)'.")
        }
        return value
    }
}

extension V3dretConfiguration {

    var baseUrl: String { value(for: "API_HOST") }
    var apiKey: String {
        let key: String = value(for: "API_KEY")
        if key.count == 0 {
            assertionFailure("OPEN_WEATHER_MAP_API_KEY not defined in V3dred.xcconfig")
        }
        return key
    }
    var imageEndpoint: String { value(for: "API_IMAGE_ENDPOINT")}
    var testis: Int { value(for: "TESTIS") }
}
