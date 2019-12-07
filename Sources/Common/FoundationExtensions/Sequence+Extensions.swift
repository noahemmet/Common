//
//  Sequence+Extensions.swift
//  Artwork
//
//  Created by Noah Emmet on 12/18/18.
//

import Foundation

public extension Sequence where Iterator.Element: Hashable {
  func uniqued() -> [Iterator.Element] {
    var seen: [Iterator.Element: Bool] = [:]
    return self.filter { seen.updateValue(true, forKey: $0) == nil }
  }
}

public extension Sequence {
  func uniqued<T: Hashable>(by map: ((Element) -> T)) -> [Element] {
    var set: Set<T> = []
    var ordered: [Element] = []
    for element in self {
      if !set.contains(map(element)) {
        set.insert(map(element))
        ordered.append(element)
      }
    }
    return ordered
  }
}
