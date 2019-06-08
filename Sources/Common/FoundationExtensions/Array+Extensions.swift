//
//  Array+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 1/28/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public extension Array {
	
	mutating func removeRandom() {
		guard let index = (0..<count).randomElement() else {
			return
		}
		self.remove(at: index)
	}
	
	mutating func removeRandom(keep: Int) {
		for _ in (0...keep) {
			let _ = self.dropRandom()
		}
	}
	
	func randomized(keep: Int) -> [Element] {
		var copy = self
		copy.removeRandom(keep: keep)
		return copy
	}
	
	mutating func dropRandom() -> Element? {
		let indexes: [Int] = (0..<count).map { $0 }
		guard let randomIndex = indexes.randomElement() else {
			return nil
		}
		let element = self[randomIndex]
		self.remove(at: randomIndex)
		return element
	}
	
	func element(at index: Int) -> Element? {
		guard index < self.count && index >= 0 else {
			return nil
		}
		return self[index]
	}
	
	func lastElement(from index: Int) -> Element? {
		let element = self.element(at: count - index)
		return element
	}
	
	func prepending(_ element: Element) -> [Element] {
		var mutatingArray = self
		mutatingArray.insert(element, at: 0)
		return mutatingArray
	}
	
	func prepending(contentsOf elements: [Element]) -> [Element] {
		var mutatingArray = self
		mutatingArray.insert(contentsOf: elements, at: 0)
		return mutatingArray
	}
	
	func appending(_ element: Element) -> [Element] {
		var mutatingArray = self
		mutatingArray.append(element)
		return mutatingArray
	}
	
	func appending(contentsOf elements: [Element]) -> [Element] {
		var mutatingArray = self
		mutatingArray.append(contentsOf: elements)
		return mutatingArray
	}
	
	func inserting(_ element: Element, at index: Int) -> [Element] {
		var mutatingArray = self
		mutatingArray.insert(element, at: index)
		return mutatingArray
	}
	
	func repeating(_ times: Int) -> [Element] {
		let repeating = Array<[Element]>(repeating: self, count: times)
		return repeating.flatMap { $0 }
	}
	
	func elements(at indexes: [Int]) -> [Element] {
		let filtered: [Element] = indexes.map { self[$0] }
		return filtered
	}
	
	@discardableResult
	mutating func removeFirst(where predicate: (Element) throws -> Bool) rethrows -> Element? {
		guard let index = try self.firstIndex(where: predicate) else {
			return nil
		}
		return remove(at: index)
	}
	
	func removingFirst(where predicate: (Element) throws -> Bool) rethrows -> [Element] {
		var copy = self
		try copy.removeFirst(where: predicate)
		return copy
	}
	
	func keyed<Key: Hashable>(by closure: (Element) -> Key ) -> [Key: [Element]] {
		return self.reduce([:]) { result, element in
			var result = result
			let key = closure(element)
			result[key, default: []].append(element)
			return result
		}
	}
}

// MARK: - Equatable

public extension Array where Element: Equatable {
	mutating func appendUnique(_ element: Element) {
		if !self.contains(element) {
			self.append(element)
		}
	}
	
	static func - (lhs: [Element], rhs: Element) -> [Element] {
		var elements = lhs
		elements.remove(rhs)
		return elements
	} 
	
	mutating func appendUnique(contentsOf elements: [Element]) {
		for element in elements {
			self.appendUnique(element)
		}
	}
	
	mutating func replaceFirst<Property: Equatable>(_ element: Element, uniquedBy keyPath: PartialKeyPath<Element>, propertyType: Property.Type = Property.self) {
		if let property = element[keyPath: keyPath] as? Property,
			let matchingIndex = self.firstIndex(where: { $0[keyPath: keyPath] as! Property == property }) {
			remove(at: matchingIndex)
			insert(element, at: matchingIndex)
		} else {
			append(element)
		}
	}
	
	mutating func remove(_ element: Element) {
		guard let index = self.firstIndex(of: element) else {
			return
		}
		self.remove(at: index)
	}
	
	mutating func removeAll(where closure: (Element) -> Bool) {
		let removable = self.filter(closure)
		for element in removable {
			self.remove(element)
		}
	}
	
	mutating func remove(contentsOf elements: [Element]) {
		for element in elements {
			self.remove(element)
		}
	}
}
