//
//  MockCache.swift
//  V3dretTests
//
//  Created by Tord Wessman on 2023-11-06.
//

import Foundation
@testable import V3dret

actor NoCache: RequestCache {

    var error: Error?
    var cachedModel: Decodable?

    init(overrideResponseUsing cachedModel: Decodable? = nil) {
        self.cachedModel = cachedModel
    }
    
    func save<RequestObject: RequestModel>(responseModel: RequestObject.ResponseType, for requestModel: RequestObject) async throws {
        if let error { throw error }
    }

    func load<RequestObject: RequestModel>(responseFor requestModel: RequestObject) async throws -> RequestObject.ResponseType? {
        if let error { throw error }
        if let cachedModel {
            return cachedModel as? RequestObject.ResponseType
        }
        return nil
    }
}
