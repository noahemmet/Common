//
//  CGRect+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 5/17/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGRect {
    
    static let w44h44 = CGRect(width: 44, height: 44)
    static let w100h100 = CGRect(width: 100, height: 100)
    static let w320h44 = CGRect(width: 320, height: 44)
    static let w320h100 = CGRect(width: 320, height: 100)
    static let w320h540 = CGRect(width: 320, height: 540)
    
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width/2, y: center.y - size.height/2)
        self.init(origin: origin, size: size)
    }
    
    init(width: CGFloat, height: CGFloat) {
        self.init(size: CGSize(width: width, height: height))
    }
    
    init(size: CGSize) {
        self.init(origin: .zero, size: size)
    }
}
