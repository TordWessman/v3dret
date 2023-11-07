//
//  RequestModel.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-02.
//

import Foundation

enum HTTPMethod: String  {

    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// Implementation represents a network request object.
protocol RequestModel: Encodable, Cacheable {

    associatedtype ResponseType : Decodable

    /// Return the resource path for this request.
    func path() -> String

    /// Return the HTTPMethod for this request.
    func method() -> HTTPMethod

    /// Implement this to append additional custom headers for the request.
    func headers() -> [String: String]?
}

extension RequestModel {

    func headers() -> [String: String]? { return nil }

    func method() -> HTTPMethod { return .get }
}
