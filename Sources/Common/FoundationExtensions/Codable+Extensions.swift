//
//  Codable+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 7/9/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public extension Encodable {
    func asJSON() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        return try dictionary.unwrap()
    }
    
    func asJSONString() throws -> String {
        let data = try JSONEncoder().encode(self)
        let string = String(data: data, encoding: .utf8)
        return try string.unwrap()
    }
}

public extension KeyedDecodingContainer {
    func value<Value: Decodable>(forKey key: Key) throws -> Value {
        let value = try self.decode(Value.self, forKey: key)
        return value
    }
}

extension Decodable {
	public static func from(_ string: String) throws -> Self {
		let data = try JSONSerialization.data(withJSON: .string(string))
		return try self.from(data)
	}
	
	public static func from(_ data: Data) throws -> Self {
		let jsonDecoder = JSONDecoder()
		let object = try jsonDecoder.decode(self, from: data)
		return object
	}
}
