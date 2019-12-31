//
//  Collection+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 12/2/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public extension Collection where Element: Numeric {
  var total: Element {
    return reduce(0, +)
  }
}

public extension Collection where Element: BinaryFloatingPoint {
  var average: Element {
    return isEmpty ? 0 : total / Element(count) 
  }
}

public extension Collection where Element: Equatable {
  func contains(_ element: Element?) -> Bool {
    guard let element = element else {
      return false
    }
    return self.contains(element)
  }

  func containsAny(_ elements: [Element]) -> Bool {
    for element in elements {
      if self.contains(element) {
        return true
      }
    }
    return false
  }

  func containsAll(_ elements: [Element]) -> Bool {
    for element in elements {
      if self.contains(element) == false {
        return false
      }
    }
    return true
  }
}

public extension Collection {
  typealias FirstAsPredicate<T> = (Element) throws -> T?
  func first<T>(as type: T.Type = T.self, where predicate: FirstAsPredicate<T>? = nil) rethrows -> T? {
    for element in self {
      if let predicate = predicate {
        guard let t = try? predicate(element) else {
          continue
        }
        return t
      } else if let t = element as? T {
        return t
      }
    }
    return nil
  }
}
