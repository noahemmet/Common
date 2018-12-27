//
//  EndpointResponding.swift
//  Common
//
//  Created by Noah Emmet on 7/25/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public protocol EndpointResponse {
    associatedtype ExpectedModel
    var result: Result<ExpectedModel> { get }
    var httpResponse: HTTPURLResponse? { get }
    init(_ httpResponse: HTTPURLResponse?, json: JSON?)
    init(_ httpResponse: HTTPURLResponse?, error: Error)
}

public struct SingleResponse<Model: Codable>: EndpointResponse {
    public typealias ExpectedModel = Model
    public var result: Result<Model>
    public var httpResponse: HTTPURLResponse?
    
    public init(_ handler: () throws -> (httpResponse: HTTPURLResponse?, model: ExpectedModel)) {
        do {
            let handled = try handler()
            let httpResponse = handled.httpResponse
            let model = handled.model
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(model)
            let json = try JSONSerialization.json(with: data, options: [])
            self.init(httpResponse, json: json)
        } catch let error {
            self.init(nil, error: error)
        }
    }
    
    public init(_ httpResponse: HTTPURLResponse?, json: JSON?) {
        self.httpResponse = httpResponse
        do {
            let anyJSON = json?.anyValue
            let jsonDecoder = JSONDecoder()
            let data = try JSONSerialization.data(withJSONObject: anyJSON ?? [:], options: [])
            let model = try jsonDecoder.decode(ExpectedModel.self, from: data)
            result = .init(value: model)
        } catch let error {
            result = .init(error: error)
        }
    }
    
    public init(_ httpResponse: HTTPURLResponse?, error: Error) {
        self.httpResponse = httpResponse
        result = .init(error: error)
    }
}

public struct ArrayResponse<Model: Codable>: EndpointResponse {
    public typealias ExpectedModel = [Model]
    public var result: Result<ExpectedModel>
    public var httpResponse: HTTPURLResponse?
    
    /// Multiple models.
    public init(_ handler: () throws -> (httpResponse: HTTPURLResponse?, models: ExpectedModel)) {
        do {
            let handled = try handler()
            let httpResponse = handled.httpResponse
            let models = handled.models
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(models)
            let json = try JSONSerialization.json(with: data, options: [])
            self.init(httpResponse, json: json)
        } catch let error {
            self.init(nil, error: error)
        }
    }
    
    public init(_ httpResponse: HTTPURLResponse?, json: JSON?) {
        self.httpResponse = httpResponse
        do {
            let jsonDecoder = JSONDecoder()
            let unwrappedJSON = try unwrap { json }
            let data = try JSONSerialization.data(withJSON: unwrappedJSON, options: [])
            let model = try jsonDecoder.decode(ExpectedModel.self, from: data)
            result = .init(value: model)
        } catch let error {
            result = .init(error: error)
        }
    }
    
    public init(_ httpResponse: HTTPURLResponse?, error: Error) {
        self.httpResponse = httpResponse
        result = .init(error: error)
    }
}
