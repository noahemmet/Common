//
//  Pathology.swift
//  Pathology
//
//  Created by Kyle Truscott on 3/1/16.
//  Copyright © 2016 keighl. All rights reserved.
//

import Foundation

//#if canImport(CoreGraphics)
//extension CGPath {
//	public func toPath() -> Path {
//		var pathData = Path(elements: [])
//		if #available(OSX 10.13, *) {
//			self.applyWithBlock { element in
//				switch (element.pointee.type) {
//				case .moveToPoint:
//					pathData.elements.append(Path.Element(type: .moveToPoint, points: [
//						element.pointee.points[0]
//						]))
//				case .addLineToPoint:
//					pathData.elements.append(Path.Element(type: .addLineToPoint, points: [
//						element.pointee.points[0],
//						]))
//				case .addQuadCurveToPoint:
//					pathData.elements.append(Path.Element(type: .addQuadCurveToPoint, points: [
//						element.pointee.points[1], // end pt
//						element.pointee.points[0], // ctlpr pt
//						]))
//				case .addCurveToPoint:
//					pathData.elements.append(Path.Element(type: .addCurveToPoint, points: [
//						element.pointee.points[2], // end pt
//						element.pointee.points[0], // ctlpr 1
//						element.pointee.points[1], // ctlpr 2
//						]))
//				case .closeSubpath:
//					pathData.elements.append(Path.Element(type: .closeSubpath, points: []))
//				}
//			}
//		} else {
//			fatalError()
//		}
//		return pathData
//	}
//}
//#endif
