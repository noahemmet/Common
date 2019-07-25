//
//  Key.swift
//  Common
//
//  Created by Noah Emmet on 9/4/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public protocol Keyed {
    var key: Key { get }
}

public extension Array where Element: Keyed {
	func keyed() -> [Key: [Element]] {
        let dict: [Key: [Element]] = Dictionary(grouping: self) { element in
            return element.key
        }
        return dict
    }
}

public struct Key: ExpressibleByStringLiteral, RawRepresentable, Hashable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue.camelCased
    }
    
    public init(_ rawValue: String) {
		self.init(rawValue: rawValue)
    }
    
    public init(keys: [Key]) {
        self.rawValue = keys.map { $0.rawValue }.joined(separator: "+")
    }
    
    public init(stringLiteral: String) {
        self.init(rawValue: stringLiteral)
    }
    
    public var subkeys: [Key] {
        let rawValues = self.rawValue.components(separatedBy: "+")
        return rawValues.map { Key(rawValue: $0) }
    }
	
	public mutating func makeUnique(length: Int = 8) {
		self = Key(rawValue + "-" + String.random(length: length))
	}
	
	public func uniquing(length: Int = 8) -> Key {
		var key = self
		key.makeUnique()
		return key
	}
}

extension Key: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self.init(rawValue)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

}

extension Collection where Element: Keyed {
	
	public func from(_ keys: [Key]) -> [Element] {
		let elements = self.filter { keys.contains($0.key) }
		return elements
	}
}
