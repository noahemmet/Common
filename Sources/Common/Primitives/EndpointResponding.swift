//
//  EndpointResponding.swift
//  Common
//
//  Created by Noah Emmet on 8/1/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Represents an object that can respond to endpoints
public protocol EndpointResponder {
// This should maybe be hidden from clients
    var dataStore: DataStore { get }
    func respond<Request: EndpointRequesting>(to request: Request) -> Request.Response
}
