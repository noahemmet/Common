//
//  Element.swift
//  Pathology
//
//  Created by Kyle Truscott on 3/2/16.
//  Copyright © 2016 keighl. All rights reserved.
//

import Foundation

public extension Path {
	enum ElementType: String, Codable, Hashable, CaseIterable {
        case invalid
        case moveToPoint
        case addLineToPoint
        case addQuadCurveToPoint
        case addCurveToPoint
        case closeSubpath
    }
    
	struct Element: Codable, Hashable {
        public var type: ElementType = .invalid
        public var points: [CGPoint] = []
		
		public init(type: ElementType, points: [CGPoint]) {
			self.type = type
			self.points = points
		}
        
        public func toDictionary() -> [String: Any] {
            return [
                "type": type.rawValue,
                "pts": points.map { return [$0.x, $0.y] }
            ]
        }
        
        public func toJSONData(options: JSONSerialization.WritingOptions) throws -> Data {
            let data = try JSONSerialization.data(withJSONObject: toDictionary(), options: options)
            return data
        }
        
        public func endPoint() -> CGPoint {
            if points.count >= 1 {
                return points[0]
            }
            return .zero
        }
        
        public func ctrlPoint1() -> CGPoint {
            if points.count >= 2 {
                return points[1]
            }
            return .zero
        }
        
        public func ctrlPoint2() -> CGPoint {
            if points.count >= 3 {
                return points[2]
            }
            return .zero
        }
    }
}

extension Path.Element {
    public init(dictionary: [String: Any]) {
        if let type = dictionary["type"] as? String {
            if let ptype = Path.ElementType(rawValue: type) {
                self.type = ptype
            }
        }
        if let points = dictionary["pts"] as? [[CGFloat]] {
            self.points = points.map({pt in
                return CGPoint(x: pt[0], y: pt[1])
            })
        }
    }
}
