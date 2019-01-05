//
//  Optional+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 2/4/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public enum UnwrapError<K>: Error {
	case failed(type: K)
    case badValue(Any, type: K)
}

public func unwrap<K>(_ closure: () throws -> K?) throws -> K {
    guard let unwrapped = try closure() else {
		throw ThrownError(UnwrapError.failed(type: K.self))
	}
	return unwrapped
}

public func unwrap<K>(orThrow error: Error, _ closure: () throws -> K?) throws -> K {
    guard let unwrapped = try closure() else {
        throw error
    }
    return unwrapped
}

public extension Optional {
	func unwrap() throws -> Wrapped {
		guard let unwrapped = self else { 
            throw ThrownError(UnwrapError.failed(type: self)) 
        }
		return unwrapped
	}
    
    func unwrap(orThrow error: @autoclosure () -> Error) throws -> Wrapped {
        guard let unwrapped = self else { 
            throw error()
        }
        return unwrapped
    }
	
	func unwrap(orThrow reason: String) throws -> Wrapped {
		guard let unwrapped = self else {
			throw ThrownError(reason)
		}
		return unwrapped
	}
}

public extension Optional where Wrapped == String {
    var isEmptyOrNil: Bool {
        if case let .some(string) = self, string.isEmpty == false {
            return false
        } else {
            return true
        }
    } 
}
