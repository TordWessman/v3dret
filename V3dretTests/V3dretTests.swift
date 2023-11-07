//
//  V3dretTests.swift
//  V3dretTests
//
//  Created by Tord Wessman on 2023-11-02.
//

import XCTest
@testable import V3dret

final class V3dretTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
       
    }

    func testSearchViewModel() async throws {

        let client = MockWebClient()
        client.response = [GeoLookupItem(name: "a", lat: 1, lon: 2, country: "SE", state: nil), GeoLookupItem(name: "b", lat: 3, lon: 4, country: "DE", state: "c")]
        let vm = await SearchViewModel(client: client)
        let loadFinishedExpectation = expectation(description: "loadFinishedExpectation")
        let loadStartedExpectation = expectation(description: "loadStartedExpectation")
        var stateCount = 0

        let sink = await vm.$state.sink { state in
            if case .loading = state {
                XCTAssertEqual(1, stateCount)
                stateCount += 1
                loadStartedExpectation.fulfill()
            } else if case let .ready(models) = state {
                XCTAssertEqual(2, stateCount)
                XCTAssertEqual(2, models.count)
                XCTAssertEqual("a", models[0].title)
                XCTAssertEqual("b (c)", models[1].title)
                loadFinishedExpectation.fulfill()
            } else if case .idle = state {
                XCTAssertEqual(0, stateCount)
                stateCount += 1
            } else {
                XCTFail("Unexpected state change: \(state)")
            }
        }

        await vm.load()
        await fulfillment(of: [loadStartedExpectation, loadFinishedExpectation], timeout: 3)
        print("sink: \(sink)")
    }

    func testDetailsViewModel() async throws {

        let client = MockWebClient()
        client.response = WeatherResponse(weather: [WeatherResponse.Description(description: "foo", icon: "bar")], main: WeatherResponse.Details(temp: 42.42, humidity: 42), wind: WeatherResponse.Wind(speed: 100, deg: 90))
        let location = LocationItemViewModel(title: "a", flagEmoji: "b", lon: 1, lat: 2, lang: "se")
        let vm = await WeatherDetailsViewModel(location: location, client: client)
        let loadFinishedExpectation = expectation(description: "loadFinishedExpectation")
        let loadStartedExpectation = expectation(description: "loadStartedExpectation")
        var stateCount = 0

        let sink = await vm.$state.sink { state in
            if case .loading = state {
                XCTAssertEqual(1, stateCount)
                stateCount += 1
                loadStartedExpectation.fulfill()
            }
            else if case let .ready(model) = state {
                XCTAssertEqual(2, stateCount)
                XCTAssertEqual("Foo", model.description)
                XCTAssertEqual("42.4", model.temperature)
                XCTAssertEqual("a", model.title)
                loadFinishedExpectation.fulfill()
            } else if case .idle = state {
                XCTAssertEqual(0, stateCount)
                stateCount += 1
            } else {
                XCTFail("Unexpected state change: \(state)")
            }
        }

        await vm.load()
        await fulfillment(of: [loadStartedExpectation, loadFinishedExpectation], timeout: 3)
        print("sink: \(sink)")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
