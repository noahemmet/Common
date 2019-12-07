//
//  UserDefaults+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 5/28/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public extension UserDefaults {
  func value<V: Codable>(ofType valueType: V.Type = V.self, forKey key: String = String(describing: V.self)) throws -> V {
    let data = try unwrap { self.data(forKey: key) }
    let jsonDecoder = JSONDecoder()
    let value = try jsonDecoder.decode(valueType, from: data)
    return value
  }

  func setValue<V: Codable>(_ value: V, forKey key: String = String(describing: V.self)) throws {
    let jsonEncoder = JSONEncoder()
    let data = try jsonEncoder.encode(value)
    self.set(data, forKey: key)
  }
}
