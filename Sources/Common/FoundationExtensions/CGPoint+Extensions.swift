// Via https://github.com/andrelind/swift-catmullrom

import Foundation
#if canImport(CoreGraphics)
  import CoreGraphics
#endif

// MARK: - Translations

public extension CGPoint {
  static func random(in frame: CGRect) -> CGPoint {
    let x = CGFloat.random(in: frame.origin.x ..< frame.origin.x + frame.width)
    let y = CGFloat.random(in: frame.origin.y ..< frame.origin.y + frame.height)
    return CGPoint(x: x, y: y)
  }
  
  static func randomPoints(in frame: CGRect, range: Range<Int>) -> [CGPoint] {
    let points: [CGPoint] = range.map { _ in
      CGPoint.random(in: frame) 
    }
    return points
  }
  
  func translate(x: CGFloat, y: CGFloat) -> CGPoint {
    return CGPoint(x: self.x + x, y: self.y + y)
  }
  
  func translate(x: CGFloat) -> CGPoint {
    return CGPoint(x: self.x + x, y: self.y)
  }
  
  func translate(y: CGFloat) -> CGPoint {
    return CGPoint(x: self.x, y: self.y + y)
  }
  
  var yInverted: CGPoint {
    return CGPoint(x: self.x, y: -self.y)
  }
  
  var xAxis: CGPoint {
    return CGPoint(x: 0, y: self.y)
  }
  
  var yAxis: CGPoint {
    return CGPoint(x: self.x, y: 0)
  }
  
  func add(to a: CGPoint) -> CGPoint {
    return CGPoint(x: self.x + a.x, y: self.y + a.y)
  }
  
  func delta(to a: CGPoint) -> CGPoint {
    return CGPoint(x: self.x - a.x, y: self.y - a.y)
  }
  
  func distanceTo(point otherPoint: CGPoint) -> CGFloat {
    let distance = hypotf(Float(otherPoint.x - x), Float(otherPoint.y - y))
    return CGFloat(distance)
  }
  
  func multiply(by value: CGFloat) -> CGPoint {
    return CGPoint(x: self.x * value, y: self.y * value)
  }
  
  var length: CGFloat {
    return CGFloat(sqrt(CDouble(
      self.x * self.x + self.y * self.y
    )))
  }
  
  var normalized: CGPoint {
    let l = self.length
    return CGPoint(x: self.x / l, y: self.y / l)
  }
}

extension CGPoint: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
  }
}

extension Array where Element == CGPoint {
  public var boundingBox: CGRect {
    guard !isEmpty else { return .zero }
    let xs = self.map { $0.x }
    let minX = xs.min()!
    let maxX = xs.max()!
    let width = maxX - minX
    
    let ys = self.map { $0.y }
    let minY = ys.min()!
    let maxY = ys.max()!
    let height = maxY - minY
    
    let box = CGRect(x: minX, y: minY, width: width, height: height)
    return box
  }
}
