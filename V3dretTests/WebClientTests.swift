//
//  WebClientTests.swift
//  V3dretTests
//
//  Created by Tord Wessman on 2023-11-06.
//

import Foundation
import XCTest
@testable import V3dret

final class WebClientTests: XCTestCase {

    func testWebClientCache() async throws {
        let requestFactory = MockRequestFactory()
        let network = MockNetworkLayer()
        let cache = NoCache(overrideResponseUsing: MockResponse(a: 444))
        let client = Client(requestFactory, cache: cache, network)
        network.response = "{ \"a\": 666 }"
        let response = try await client.send(request: MockRequest(v1: "v1", v2: 42))
        XCTAssertEqual(444, response.a)
    }

    func testWebClientSuccess() async throws {
        let requestFactory = MockRequestFactory()
        let network = MockNetworkLayer()
        let client = Client(requestFactory, cache: NoCache(), network)
        network.response = "{ \"a\": 666 }"
        let response = try await client.send(request: MockRequest(v1: "v1", v2: 42))
        XCTAssertEqual(666, response.a)
    }

    func testWebClientHttpError() async throws {
        let requestFactory = MockRequestFactory()
        let network = MockNetworkLayer()
        let client = Client(requestFactory, cache: NoCache(), network)
        network.statusCode = 666
        let httpErrorExpectation = expectation(description: "httpErrorExpectation")

        do { try await client.send(request: MockRequest(v1: "v1", v2: 42)) }
        catch Client.Error.invalidResponseCode(let code) {
            XCTAssertEqual(666, code)
            httpErrorExpectation.fulfill()
        }

        await fulfillment(of: [httpErrorExpectation], timeout: 3)
    }
    func testWebClientRequestError() async throws {

        let requestFactory = MockRequestFactory()
        let network = MockNetworkLayer()
        let client = Client(requestFactory, cache: NoCache(), network)
        network.error = TestError.a

        let errorExpectation = expectation(description: "errorExpectation")

        do { try await client.send(request: MockRequest(v1: "v1", v2: 42)) }
        catch TestError.a {
            errorExpectation.fulfill()
        }

        await fulfillment(of: [errorExpectation], timeout: 3)
    }
}
