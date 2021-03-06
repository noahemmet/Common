//
//  Key.swift
//  Common
//
//  Created by Noah Emmet on 9/4/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

// MARK: - Keyed

public protocol Keyed {
  var key: Key { get set }
}

public extension Collection where Element: Keyed {
  var keys: [Key] {
    return self.map { $0.key }
  }

  func keyed() -> [Key: [Element]] {
    let dict: [Key: [Element]] = Dictionary(grouping: self) { element in
      return element.key
    }
    return dict
  }

  /// Returns an array of the same element, but with unique keys if necessary
  func uniquedKeys(appendixLength: Int = 8) -> [Element] {
    let keys = map { $0.key }
    /// Add some random string junk to the end of every non-unique key
    let uniquelyKeyedElements: [Element] = map { element in 
      let existingElementKeyCount = keys.filter { $0 == element.key }.count
      if existingElementKeyCount > 1 {
        // Non-unique; add unique string.
        var new = element
        new.key = Key(new.key.rawValue + String.random(length: appendixLength))
        return new
      }
      return element
    }
    return uniquelyKeyedElements
  }
}

// MARK: - Key

public struct Key: ExpressibleByStringLiteral, RawRepresentable, Hashable {
  public let rawValue: String

  /// Uses the raw string.
  public init(rawValue: String) {
    self.rawValue = rawValue
  }

  /// Converts the string to lowerCamelCase.
  public init(_ text: String) {
    self.rawValue = text.lowerSnakeCased
  }

  public init(keys: [Key]) {
    self.rawValue = keys.map { $0.rawValue }.joined(separator: "+")
  }

  public init(stringLiteral: String) {
    self.init(stringLiteral)
  }

  public var subkeys: [Key] {
    let rawValues = self.rawValue.components(separatedBy: "+")
    return rawValues.map { Key(rawValue: $0) }
  }

  public mutating func makeUnique(length: Int = 8) {
    self = Key(rawValue: rawValue + "_" + String.random(length: length))
  }

  public func uniquing(length: Int = 8) -> Key {
    var key = self
    key.makeUnique()
    return key
  }
}

extension Key: CustomDebugStringConvertible {
  public var debugDescription: String {
    return rawValue
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
