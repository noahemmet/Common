//
//  File.swift
//  
//
//  Created by Noah Emmet on 8/12/19.
//

import Foundation

public protocol GKeyed {
	var key: GKey<Self> { get }
}

/// A key that's generic over an item.
public struct GKey<Item>: Hashable, ExpressibleByStringLiteral {
	public var key: Key
	public static var itemType: Item.Type { return Item.self }
	
	public init(_ rawValue: String) {
		key = Key(rawValue)
	}
	
	public init(_ key: Key) {
		self.key = key
	}
	
	public init(stringLiteral: String) {
		self.init(stringLiteral)
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
		try container.encode(key)
	}
	
}

extension Collection where Element: GKeyed {
	public func filter(with keys: [GKey<Element>]) -> [Element] {
		return self.filter { keys.contains($0.key) }
	}
}
