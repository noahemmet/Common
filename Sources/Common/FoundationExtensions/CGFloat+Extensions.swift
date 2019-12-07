//
//  CGFloat+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 8/3/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation
#if canImport(CoreGraphics)
  import CoreGraphics
#endif

public extension CGFloat {
  func random(within delta: CGFloat) -> CGFloat {
    let sign: CGFloat = Bool.random() ? 1 : -1
    let newValue = self + (sign * delta)
    return newValue
  }
  
  func random(within range: Range<CGFloat>) -> CGFloat {
    let delta = CGFloat.random(in: range)
    let newValue = random(within: delta)
    return newValue
  }
  
  mutating func randomize(within delta: CGFloat) {
    let randomDelta = self.random(within: delta)
    self += randomDelta
  }
  
  mutating func randomize(within range: Range<CGFloat>) {
    let randomDelta = self.random(within: range)
    self += randomDelta
  }
}

public extension Float {
  func random(within delta: Float) -> Float {
    let sign: Float = Bool.random() ? 1 : -1
    let newValue = self + (sign * delta)
    return newValue
  }
  
  func random(within range: Range<Float>) -> Float {
    let delta = Float.random(in: range)
    let newValue = random(within: delta)
    return newValue
  }
  
  mutating func randomize(within delta: Float) {
    let randomDelta = self.random(within: delta)
    self += randomDelta
  }
  
  mutating func randomize(within range: Range<Float>) {
    let randomDelta = self.random(within: range)
    self += randomDelta
  }
}

public extension Double {
  func random(within delta: Double) -> Double {
    let sign: Double = Bool.random() ? 1 : -1
    let change: Double = Double.random(in: 0..<delta)
    let newValue = self + (sign * change)
    return newValue
  }
  
  func random(within range: Range<Double>) -> Double {
    let delta = Double.random(in: range)
    let newValue = random(within: delta)
    return newValue
  }
  
  mutating func randomize(within delta: Double, clipTo bounds: Range<Double>?) {
    let randomDelta = self.random(within: delta)
    var new = self + randomDelta
    if let bounds = bounds {
      new = max(bounds.lowerBound, new)
      new = min(bounds.upperBound, new)
    }
    self = new
  }
  
  mutating func randomize(within range: Range<Double>) {
    let randomDelta = self.random(within: range)
    self += randomDelta
  }
}
