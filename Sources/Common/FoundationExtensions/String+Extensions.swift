//
//  String+Extensions.swift
//  Common
//
//  Created by Noah Emmet on 8/11/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation

public extension String {
	func droppingPrefix(_ prefix: String) -> String {
		guard hasPrefix(prefix) else { return self }
		let newString = self.dropFirst(prefix.count)
		return String(newString)
	}
	
	func droppingUntil(_ match: String) -> String {
		guard let range = self.range(of: match) else { return self }
		var newString = self
		newString.removeSubrange(self.startIndex..<range.lowerBound)
		return newString
	}
	
	func prepending(_ prefix: String) -> String {
		return prefix + self
	}
	
	func capitalizingFirstLetter() -> String {
		return prefix(1).uppercased() + dropFirst()
	}
	
	var uppercasingFirst: String {
		return prefix(1).uppercased() + dropFirst()
	}
	
	var lowercasingFirst: String {
		return prefix(1).lowercased() + dropFirst()
	}
	
	var camelCased: String {
		guard !isEmpty else {
			return ""
		}
		
		let parts = self.components(separatedBy: CharacterSet.alphanumerics.inverted)
		
		let first = String(describing: parts.first!).lowercasingFirst
		let rest = parts.dropFirst().map({String($0).uppercasingFirst})
		
		return ([first] + rest).joined(separator: "")
	}
	
	/// Downcases the string and replaces whitespace with a `_`. Useful for keys.
	var normalized: String {
		return self.lowercased().replacingOccurrences(of: " ", with: "_")
	}
}

// MARK: - Splitting

public extension String {
	
	/// https://stackoverflow.com/a/31727051
	func slice(from: String, to: String) -> String? {
		return (range(of: from)?.upperBound).flatMap { substringFrom in
			(range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
				String(self[substringFrom..<substringTo])
			}
		}
	}
	
	func words() -> [String] {
		let range = startIndex..<endIndex
		var words: [String] = []
		self.enumerateSubstrings(in: range, options: .byWords) { (substring, _, _, _) in
			words.append(substring ?? "")
		}
		return words
	}
	
	enum WordSplitResult {
		case match(String)
		case between(String)
		
		public var asMatch: String? {
			if case .match(let match) = self {
				return match
			} else {
				return nil
			}
		}
		
		public var asBetween: String? {
			if case .between(let between) = self {
				return between
			} else {
				return nil
			}
		}
	}
	
	func words(splitBy delimiter: String) -> [WordSplitResult] {
		let regex = try! NSRegularExpression(pattern: "#[a-z0-9]+", options: .caseInsensitive)
		
		let string = self as NSString
		let matchResults: [(match: String, result: NSTextCheckingResult)] = regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map { result in
			let match = string.substring(with: result.range)
			return (match: match, result: result)
		}
		
		// If there are no matches, return self.
		guard matchResults.isEmpty == false else {
			return [.between(self)]
		}
		
		var wordSplitResults: [WordSplitResult] = []
		for (index, matchResult) in matchResults.enumerated() {
			// append the previous inbetween text
			if index == 0 {
				let firstBetween = string.substring(to: matchResult.result.range.location)
				wordSplitResults.append(.between(firstBetween))
			} else if let previousElement = matchResults.element(at: index-1) {
				let range = NSRange(location: previousElement.result.range.upperBound, length: matchResult.result.range.location - previousElement.result.range.upperBound)
				let previousBetween = string.substring(with: range)
				wordSplitResults.append(.between(previousBetween))
			}
			// append the match
			wordSplitResults.append(.match(matchResult.match))
			
			// append the last inbetween, if any
			let isLast = (matchResults.count == index+1)
			if isLast {
				let lastMatchIndex = matchResult.result.range.location + matchResult.result.range.length
				let endText = string.substring(from: lastMatchIndex)
				wordSplitResults.append(.between(endText))
			}
		}
		return wordSplitResults
	}
}

// https://stackoverflow.com/a/24144365

public extension String {
	subscript (i: Int) -> Character {
		return self[index(startIndex, offsetBy: i)]
	}
	subscript (bounds: CountableRange<Int>) -> Substring {
		let start = index(startIndex, offsetBy: bounds.lowerBound)
		let end = index(startIndex, offsetBy: bounds.upperBound)
		return self[start ..< end]
	}
	subscript (bounds: CountableClosedRange<Int>) -> Substring {
		let start = index(startIndex, offsetBy: bounds.lowerBound)
		let end = index(startIndex, offsetBy: bounds.upperBound)
		return self[start ... end]
	}
	subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
		let start = index(startIndex, offsetBy: bounds.lowerBound)
		let end = index(endIndex, offsetBy: -1)
		return self[start ... end]
	}
	subscript (bounds: PartialRangeThrough<Int>) -> Substring {
		let end = index(startIndex, offsetBy: bounds.upperBound)
		return self[startIndex ... end]
	}
	subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
		let end = index(startIndex, offsetBy: bounds.upperBound)
		return self[startIndex ..< end]
	}
}

public extension Substring {
	subscript (i: Int) -> Character {
		return self[index(startIndex, offsetBy: i)]
	}
	subscript (bounds: CountableRange<Int>) -> Substring {
		let start = index(startIndex, offsetBy: bounds.lowerBound)
		let end = index(startIndex, offsetBy: bounds.upperBound)
		return self[start ..< end]
	}
	subscript (bounds: CountableClosedRange<Int>) -> Substring {
		let start = index(startIndex, offsetBy: bounds.lowerBound)
		let end = index(startIndex, offsetBy: bounds.upperBound)
		return self[start ... end]
	}
	subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
		let start = index(startIndex, offsetBy: bounds.lowerBound)
		let end = index(endIndex, offsetBy: -1)
		return self[start ... end]
	}
	subscript (bounds: PartialRangeThrough<Int>) -> Substring {
		let end = index(startIndex, offsetBy: bounds.upperBound)
		return self[startIndex ... end]
	}
	subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
		let end = index(startIndex, offsetBy: bounds.upperBound)
		return self[startIndex ..< end]
	}
}
