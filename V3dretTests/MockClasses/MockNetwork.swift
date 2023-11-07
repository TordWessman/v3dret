//
//  MockNetwork.swift
//  V3dretTests
//
//  Created by Tord Wessman on 2023-11-06.
//

import Foundation
@testable import V3dret

class MockNetworkLayer: NetworkLayer {

    var response: String = ""
    var error: Error? = nil
    var statusCode: Int = 200

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {

        if let error { throw error }

        let data = response.data(using: .utf8)!
        let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        return (data, response as URLResponse)
    }
}
