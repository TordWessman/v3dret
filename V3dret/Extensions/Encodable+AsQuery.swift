//
//  Encodable+AsQuery.swift
//  V3dret
//
//  Created by Tord Wessman on 2021-03-02.
//

import Foundation

enum EncodingError: Error {
    case typeMissmatch
}

extension Encodable {

    /** Creates a dictionary with `QueryStringParameter` values of the model. */
    func asDictionary() throws -> [String: Any] {

        let parametersData = try JSONEncoder().encode(self)
        let parameters = try JSONSerialization.jsonObject(with: parametersData, options: .allowFragments)

        guard let dictionary = parameters as? [String: Any] else {
            throw EncodingError.typeMissmatch
        }

        return dictionary
    }

    /** Encodes object as a query string parameterized string. */
    func asQuery() throws -> [URLQueryItem] {

        var queryItems = [URLQueryItem]()

        let parameters = try asDictionary()

        for parameter in parameters {
            queryItems.append(URLQueryItem(name: parameter.key, value: "\(parameter.value)"))
        }

        return queryItems
    }
}
