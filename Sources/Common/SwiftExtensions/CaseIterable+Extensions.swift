//
//  CaseIterable+Extensions.swift
//  
//
//  Created by Noah Emmet on 6/29/19.
//

import Foundation

extension CaseIterable where Self: Equatable {
	public var other: AllCases.Element {
		assert(Self.allCases.count >= 2)
		var next: AllCases.Element = self
		repeat {
			next = Self.allCases.randomElement()!
		} while next == self
		return next
	}
}
