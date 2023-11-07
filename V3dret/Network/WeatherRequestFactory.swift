//
//  WeatherRequestFactory.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-02.
//

import Foundation

class WeatherRequestFactory: RequestFactory {

    enum Error: Swift.Error {
        case argh
        case url
        case httpMethodNotSupported(HTTPMethod)
    }

    private let host: String = V3dretConfiguration.shared.baseUrl
    private let basePath: String = "/"
    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    public func createRequest<RequestType>(request: RequestType) throws -> URLRequest where RequestType: RequestModel {

        guard var components = URLComponents(string: host) else {
            throw Error.argh
        }

        components.path = basePath + request.path()

        var queryItems = components.queryItems ?? [URLQueryItem]()

        if request.method() == .get || request.method() == .delete {
            queryItems += try request.asQuery()
        }

        components.queryItems = queryItems
        components.queryItems?.append(URLQueryItem(name: "appid", value: apiKey))

        guard let url = components.url else {
            throw Error.url
        }

        var urlRequest = URLRequest(url: url)

        if [HTTPMethod.post, HTTPMethod.put].contains(request.method()) {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        }
        
        urlRequest.httpMethod = request.method().rawValue
        return urlRequest
    }
}
