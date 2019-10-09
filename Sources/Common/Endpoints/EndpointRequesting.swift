//
//  EndpointRequesting.swift
//  Common
//
//  Created by Noah Emmet on 7/25/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public protocol EndpointRequesting {
    associatedtype Response: EndpointResponse
    var path: String { get }
    func response(_ httpResponse: HTTPURLResponse?, json: JSON?) throws -> Response
}

extension EndpointRequesting {
    public func response(_ httpResponse: HTTPURLResponse?, json: JSON?) throws -> Response {
        let response = Response(httpResponse, json: json)
        return response
    }
}
