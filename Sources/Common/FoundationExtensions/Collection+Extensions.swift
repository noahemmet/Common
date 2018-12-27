//
//  Collection+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 12/2/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public extension Collection where Element: Numeric {
    var total: Element {
        return reduce(0, +)
    }
}

public extension Collection where Element: BinaryFloatingPoint {
    var average: Element {
        return isEmpty ? 0 : total / Element(count) 
    }
}
