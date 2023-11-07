//
//  MockRequestFactory.swift
//  V3dretTests
//
//  Created by Tord Wessman on 2023-11-06.
//

import Foundation

@testable import V3dret

class MockRequestFactory: RequestFactory {

    var urlRequest: URLRequest? = nil
    var error: Error? = nil

    func createRequest<RequestType>(request: RequestType) throws -> URLRequest where RequestType: RequestModel {
        if let error { throw error }
        if let urlRequest { return urlRequest }
        return URLRequest(url: URL(string: "https://example.com")!)
    }
}
