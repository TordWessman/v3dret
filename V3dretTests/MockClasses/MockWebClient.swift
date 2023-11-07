//
//  MockNetworkFacade.swift
//  V3dretTests
//
//  Created by Tord Wessman on 2023-11-06.
//

import Foundation
@testable import V3dret

class MockWebClient: WebClient {

    var response: Any!
    var error: Error? = nil

    @discardableResult
    func send<RequestType: RequestModel>(request: RequestType) async throws -> RequestType.ResponseType {

        if let error {
            throw error
        }

        return response as! RequestType.ResponseType
    }
}
