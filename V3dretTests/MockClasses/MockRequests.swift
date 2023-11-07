//
//  MockRequests.swift
//  V3dretTests
//
//  Created by Tord Wessman on 2023-11-06.
//

import Foundation
@testable import V3dret

enum TestError: Error {
    case a
    case b
}

struct MockResponse: Decodable {
    let a: Int
}
struct MockRequest: RequestModel {

    typealias ResponseType = MockResponse

    let v1: String
    let v2: Int

    func path() -> String { "" }
}
