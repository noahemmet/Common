//
//  CGSize+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 5/17/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation
#if canImport(CoreGraphics)
  import CoreGraphics
#endif

public extension CGSize {
  init(dimension: CGFloat) {
    self.init(width: dimension, height: dimension)
  }
  
  mutating func scale(by scale: CGFloat) {
    self = CGSize(width: width * scale, height: height * scale)
  }
  
  func scaled(by scale: CGFloat) -> CGSize {
    return CGSize(width: width * scale, height: height * scale)
  }
  
  func inset(by inset: CGFloat) -> CGSize {
    return CGSize(width: width - inset, height: height - inset)
  }
  
  func inset(width widthInset: CGFloat, height heightInset: CGFloat) -> CGSize {
    return CGSize(width: widthInset, height: heightInset)
  }
  
  var minDimension: CGSize {
    return CGSize(dimension: min(width, height))
  }
  
  var maxDimension: CGSize {
    return CGSize(dimension: max(width, height))
  }
}

extension CGSize: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(width)
    hasher.combine(height)
  }
}
