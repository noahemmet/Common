//
//  File.swift
//  
//
//  Created by Noah Emmet on 8/12/19.
//

import Foundation

// MARK: - GKeyed

public protocol GKeyed {
	var key: GKey<Self> { get set }
}

public extension Collection where Element: GKeyed {
	
	/// Returns an array of the same element, but with unique keys if necessary
	func uniquedKeys(appendixLength: Int = 8) -> [Element] {
		let keys = map { $0.key }
		/// Add some random string junk to the end of every non-unique key
		let uniquelyKeyedElements: [Element] = map { element in 
			let existingElementKeyCount = keys.filter { $0 == element.key }.count
			if existingElementKeyCount > 1 {
				// Non-unique; add unique string.
				var new = element
				new.key = GKey(new.key.rawValue + String.random(length: appendixLength))
				return new
			}
			return element
		}
		return uniquelyKeyedElements
	}
}

// MARK: - GKey

/// A key that's generic over an item.
public struct GKey<Item: GKeyed>: Hashable, ExpressibleByStringLiteral {
	public var rawKey: Key
	public var rawValue: String { return rawKey.rawValue }
	public static var itemType: Item.Type { return Item.self }
	
	public init(_ rawValue: String) {
		rawKey = Key(rawValue)
	}
	
	public init(_ key: Key) {
		self.rawKey = key
	}
	
	public init(stringLiteral: String) {
		self.init(stringLiteral)
	}
	
	public mutating func makeUnique(length: Int = 8) {
		self.rawKey.makeUnique()
	}
	
	public func uniquing(length: Int = 8) -> GKey {
		var key = self
		key.makeUnique()
		return key
	}
}

extension GKey: CustomDebugStringConvertible {
	public var debugDescription: String {
		return "<\(Item.self)>\(rawValue)"
	}
}

extension GKey: Codable {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let key = try container.decode(Key.self)
		self.init(key)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(rawKey)
	}
	
}

extension Collection where Element: GKeyed {
	
	public var keys: [GKey<Element>] {
		return self.map { $0.key }
	}
	
	public func filter(with keys: [GKey<Element>]) -> [Element] {
		return self.filter { keys.contains($0.key) }
	}
	
	public func first(with key: GKey<Element>) throws -> Element {
		return try self.first(where: { $0.key == key }).unwrap(orThrow: "Element not found with key: \(key)")
	}
}
