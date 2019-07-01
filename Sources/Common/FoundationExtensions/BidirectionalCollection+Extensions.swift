import Foundation

public extension BidirectionalCollection where Element: Equatable {
	
	// https://stackoverflow.com/a/45340537
	func after(_ item: Element, loop: Bool = false) -> Element? {
		if let itemIndex = self.firstIndex(of: item) {
			let lastItem: Bool = (index(after:itemIndex) == endIndex)
			if loop && lastItem {
				return self.first
			} else if lastItem {
				return nil
			} else {
				return self[index(after:itemIndex)]
			}
		}
		return nil
	}
	
	func before(_ item: Element, loop: Bool = false) -> Element? {
		if let itemIndex = self.firstIndex(of: item) {
			let firstItem: Bool = (itemIndex == startIndex)
			if loop && firstItem {
				return self.last
			} else if firstItem {
				return nil
			} else {
				return self[index(before:itemIndex)]
			}
		}
		return nil
	}
	
	func neighbors(around element: Element, loop: Bool = false) -> [Element] {
		let prev = self.before(element, loop: loop)
		let next = self.after(element, loop: loop)
		return [prev, next].compactMap { $0 }
	}
}

