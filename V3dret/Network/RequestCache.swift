//
//  RequestCache.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-06.
//

import Foundation
import CryptoKit

fileprivate typealias MD5Hash = String

protocol Cacheable {

    /// Determines how long can this object type be cashed. Set to ´0´ to omitt caching.
    func ttl() -> TimeInterval
}

extension Cacheable {

    static var DefaultCacheTime: TimeInterval { 5 * 60 }

    func ttl() -> TimeInterval { Self.DefaultCacheTime }
}

fileprivate extension RequestModel {

    func checkSum() throws -> MD5Hash {

        let data = try JSONEncoder().encode(self)
        let computed = CryptoKit.Insecure.MD5.hash(data: data)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}

protocol RequestCache: Actor {

    /// Save ´responseModel´ to cache using ´requestModel´ as a reference.
    func save<RequestObject: RequestModel>(responseModel: RequestObject.ResponseType, for requestModel: RequestObject) async throws

    /// Load a model of type ´RequestObject.ResponseType´ using ´requestModel´as a reference. Returns ´nil´ if no object matches the entry or type.
    func load<RequestObject: RequestModel>(responseFor requestModel: RequestObject) async throws -> RequestObject.ResponseType?
}

/// Simple, memory-devouring cache.
actor SimpleMemoryCache: RequestCache {

    fileprivate struct Container {
        let model: Decodable
        let expiration: Date
    }

    private var cache: [MD5Hash: Container] = [:]
    private let dateProvider: () -> Date

    init(dateProvider: @escaping () -> Date = Date.init) {
        self.dateProvider = dateProvider
    }

    func save<RequestObject: RequestModel>(responseModel: RequestObject.ResponseType, for requestModel: RequestObject) async throws {
        guard requestModel.ttl() > 0 else { return }
        let container = Container(model: responseModel, expiration: dateProvider().addingTimeInterval(requestModel.ttl()))
        cache[try requestModel.checkSum()] = container
    }

    func load<RequestObject: RequestModel>(responseFor requestModel: RequestObject) async throws -> RequestObject.ResponseType? {
        let checksum = try requestModel.checkSum()

        guard let container = cache[checksum] else {
            return nil
        }

        guard container.expiration >= dateProvider() else {
            cache[checksum] = nil
            return nil
        }

        return container.model as? RequestObject.ResponseType
    }
}
