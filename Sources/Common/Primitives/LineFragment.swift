//
//  LineFragment.swift
//  FingerPaint
//
//  Created by Noah Emmet on 4/13/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public enum LineFragment {
  case free([TouchPoint])
  case straight([(TouchPoint, TouchPoint)])
  case finished

//    public static func == (lhs: LineFragment, rhs: LineFragment) -> Bool {
//        switch lhs {
//        case .free(let lhsPoints):
//            guard case let .free(rhsPoints) = rhs else { return false }
//            return lhsPoints == rhsPoints
//        case .line(let lhsPoints):
//            guard case let .line(rhsPoints) = rhs else { return false }
//            return lhsPoints.elementsEqual(rhsPoints) { (p1, p2) in
//                return p1 == p2
//            }
//        case .finished:
//            return rhs == .finished
//        }
//    }

  public static func split(fragments: [LineFragment]) -> [[LineFragment]] {
    let split = fragments.split(whereSeparator: { fragment in 
      if case .finished = fragment {
        return true
      } else {
        return false
      }
    })
    return split.map { Array($0) }
  }
}

