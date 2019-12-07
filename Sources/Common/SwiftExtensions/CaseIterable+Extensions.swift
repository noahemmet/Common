//
//  CaseIterable+Extensions.swift
//  
//
//  Created by Noah Emmet on 6/29/19.
//

import Foundation

extension CaseIterable where Self: Equatable {
  public var other: AllCases.Element {
    assert(Self.allCases.count >= 2)
    var other: AllCases.Element = self
    repeat {
      other = Self.allCases.randomElement()!
    } while other == self
    return other
  }

  public var next: AllCases.Element {
    let allCases = Self.allCases
    let index = allCases.firstIndex(of: self)!
    let nextIndex = allCases.index(after: index)
    let next = allCases[nextIndex == allCases.endIndex ? allCases.startIndex : nextIndex]
    return next
  }
}
