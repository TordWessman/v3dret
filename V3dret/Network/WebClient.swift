//
//  NetworkFacade.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-02.
//

import Foundation

/// Representation of an entity capable of issuing network requests.
protocol WebClient {

    @discardableResult
    func send<RequestType: RequestModel>(request: RequestType) async throws -> RequestType.ResponseType
}

protocol RequestFactory {

    func createRequest<RequestType>(request: RequestType) throws -> URLRequest where RequestType: RequestModel
}

/// Default ´WebClient´ implementation.
class Client: WebClient {

    enum Error: Swift.Error {
        case argh
        case cancelled
        case connection(underlyingError: Swift.Error)
        case responseType(response: URLResponse?)
        case invalidResponseCode(code: Int)
    }

    private let network: NetworkLayer
    private let cache: RequestCache
    private let requestFactory: RequestFactory

    init(_ requestFactory: RequestFactory, cache: RequestCache = SimpleMemoryCache(), _ network: NetworkLayer = URLSession.shared) {
        self.requestFactory = requestFactory
        self.cache = cache
        self.network = network
    }

    @discardableResult
    func send<RequestType: RequestModel>(request: RequestType) async throws -> RequestType.ResponseType {
        
        if let cachedResponse = try await cache.load(responseFor: request) {
            return cachedResponse
        }

        let urlRequest = try requestFactory.createRequest(request: request)

        var data: Data
        var response: URLResponse

        do {
            (data, response) = try await network.data(for: urlRequest)
            try Task.checkCancellation()
        } catch (_ as CancellationError) {
            throw Error.cancelled
        } catch {
            throw error
        }

        guard let response = response as? HTTPURLResponse else {
            throw Error.responseType(response: response)
        }

        guard response.statusCode == 200 else  {
            throw Error.invalidResponseCode(code: response.statusCode)
        }

        let responseModel = try JSONDecoder().decode(RequestType.ResponseType.self, from: data)

        try await cache.save(responseModel: responseModel, for: request)
        return responseModel

    }
}

/// The network layer is supposed to represent the `raw` communication interface.
public protocol NetworkLayer {

    /// Imitates the implementation of `URLSession`.
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkLayer { }
