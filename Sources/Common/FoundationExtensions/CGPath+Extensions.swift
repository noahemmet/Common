//
//  CGPath+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 8/3/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

//#if canImport(CoreGraphics)
//public extension CGPath {
//
//    public enum CodingError: Error {
//        case unknown
//    }
//
//    public func data() throws -> Data {
//        let path = self.toPath()
//        let data = try path.toJSONData(options: [])
//        return data
//    }
//
//    static func from(data: Data) throws -> CGPath {
//        let path = try Path(data: data)
//        let cgPath = path.toCGPath()
//        return cgPath
//    }
//
//    class func random(in frame: CGRect, curves curveRange: Range<Int>) -> CGPath {
//        let path = CGMutablePath()
//        let firstPoint = CGPoint.random(in: frame)
//        path.move(to: firstPoint)
//
//        let numCurves = Int.random(in: curveRange)
//        for _ in 0 ..< numCurves {
//            path.addQuadCurve(to: CGPoint.random(in: frame), control: CGPoint.random(in: frame))
//        }
//        return path
//    }
//}
//#endif
