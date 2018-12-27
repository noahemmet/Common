//
//  DictionaryExtensions.swift
//  FingerPaint
//
//  Created by Noah Emmet on 4/13/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

extension Dictionary {
    public enum Error: Swift.Error {
        case unknownValue(Key)
    }
    public func value<V>(for key: Key) throws -> V {
        guard let value = self[key] as? V else {
            throw Error.unknownValue(key)
        }
        return value
    }
}

public extension Dictionary where Value: Equatable {
    func subtracting(_ other: Dictionary) -> Dictionary {
        var copy = self
        for (key, _) in self {
            if let _ = other[key] {
                copy[key] = nil
            }
        }
        return copy
    }
    
    
}
