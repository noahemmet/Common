//
//  Result.swift
//  Common
//
//  Created by Noah Emmet on 5/22/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public enum Result<Value> {
    case success(Value)
    case failure(Error)
    
    public init(value: Value?, error: Error?) {
        if let error = error {
            self = .failure(error)
        } else if let value = value {
            self = .success(value)
        } else {
            self = .failure(DefaultError.reason("nil value and error"))
        }
    }
    
    public init(value: Value) {
        self = .success(value)
    }
    
    public init(error: Error) {
        self = .failure(error)
    }
    
    public var value: Value? {
        if case let .success(value) = self {
            return value
        } else {
            return nil
        }
    }
    
    public func getValue() throws -> Value {
        switch self {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
    
    public var error: Error? {
        if case let .failure(error) = self {
            return error
        } else {
            return nil
        }
    }
    
    public enum DefaultError: Error {
        case general
        case reason(String)
    }
}
