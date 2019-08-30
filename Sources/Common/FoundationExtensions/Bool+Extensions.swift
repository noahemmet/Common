//
//  Bool+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 6/21/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
	
	mutating func setTrue() {
		self = true
	}
	
	mutating func setFalse() {
		self = false
	}
}

extension Optional where Wrapped == Bool {
	public var isTrueOrNil: Bool {
		switch self {
		case .some(let bool):
			return bool
		case .none:
			return true
		}
	}
}
