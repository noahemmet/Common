//
//  TouchPoint.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/28/17.
//  Copyright © 2017 Sticks. All rights reserved.
//

import Foundation
#if canImport(CoreGraphics)
  import CoreGraphics
#endif

public struct TouchPoint: Equatable {
  public var center: CGPoint
  public init(_ center: CGPoint) {
    self.center = center
  }
}

extension Array where Element == TouchPoint {
  public var cgPoints: [CGPoint] {
    return self.map { $0.center }
  }
}

extension TouchPoint: CustomDebugStringConvertible {
  public var debugDescription: String {
    return String(describing: center)
  }
}
