//
//  File.swift
//  
//
//  Created by Noah Emmet on 8/20/19.
//

import Foundation

public extension String {
	
	func tokenize(by characterSet: CharacterSet) -> [String] {
		var result: [String] = []
		var pos = startIndex
		while let range = rangeOfCharacter(from: characterSet, range: pos..<endIndex) {
			// Append string preceding the split mark:
			if range.lowerBound != pos {
				let string = self[pos..<range.lowerBound]
				result.append(String(string))
			}
			// Append split mark:
			let string = self[range]
			result.append(String(string))
			// Update position for next search:
			pos = range.upperBound
		}
		// Append string following the last split mark:
		if pos != endIndex {
			let string = self[pos..<endIndex]
			result.append(String(string))
		}
		return result
	}
	
	enum TokenizeResult {
		case token(String)
		case text(String)
		
		public var asToken: String? {
			if case .token(let token) = self {
				return token
			} else {
				return nil
			}
		}
		
		public var asText: String? {
			if case .text(let text) = self {
				return text
			} else {
				return nil
			}
		}
	}
	
	func tokenize(prefix: String, until suffix: String, dropPrefix: Bool = true, options: String.CompareOptions = []) -> [TokenizeResult] {
		return self.tokenize(prefix: prefix, untilEither: .right(suffix), dropPrefix: dropPrefix, options: options)
	}
	
	func tokenize(prefix: String, untilAny suffix: CharacterSet = CharacterSet.whitespaces.union(.punctuationCharacters), dropPrefix: Bool = true, options: String.CompareOptions = []) -> [TokenizeResult] {
		return self.tokenize(prefix: prefix, untilEither: .left(suffix), dropPrefix: dropPrefix, options: options)
	}
	
	private func tokenize(prefix: String, untilEither suffix: Either<CharacterSet, String>, dropPrefix: Bool = true, options: String.CompareOptions = []) -> [TokenizeResult] {
		guard self.contains(prefix) else {
			// If we don't contain the prefix at all, no need to search for it.
			return [.text(self)]
		}
		
		var result: [TokenizeResult] = []
//		let prefixSet = CharacterSet(charactersIn: prefix)
		var pos = startIndex
		while let prefixRange = range(of: prefix, options: options, range: pos..<endIndex) {
			// Append string preceding the first token.
			if prefixRange.lowerBound != pos {
				let previousText = String(self[pos..<prefixRange.lowerBound])
				let text: String
				if let lastToken = result.last?.asToken {
					// If we've already grabbed a token, remove it from the next non-match.
					let prefixToDrop: String
					if dropPrefix {
						prefixToDrop = lastToken
					} else {
						prefixToDrop = String(lastToken.dropFirst(prefix.count))
					}
					text = previousText.droppingPrefix(prefixToDrop)
				} else {
					text = previousText
				}
				result.append(.text(text))
			}
			
			// Get range of suffix. If no match, that means we're at the end of the string, and you can include everything from the prefix on up.
			let indexAfterPrefix = self.index(after: prefixRange.lowerBound)
			var token: String
			let suffixRange: Range<String.Index>?
			switch suffix {
			case .left(let characterSet):
				suffixRange = rangeOfCharacter(from: characterSet, options: options, range: indexAfterPrefix ..< endIndex)
			case .right(let string):
				suffixRange = range(of: string)
			}
			if let suffixRange = suffixRange {
				token = String(self[prefixRange.lowerBound ..< suffixRange.lowerBound])
			} else {
				token = String(self[prefixRange.lowerBound ..< endIndex])
			}
			// Append the token.
			if dropPrefix {
				token.dropPrefix(prefix)
			}
			result.append(.token(token))
			
			// Update position for next search.
			pos = prefixRange.upperBound
		}
		
		// Append string following the last token.
		if pos != endIndex {
			let endOfString = String(self[pos..<endIndex])
			let endOfLastMatchToEndOfString: String
			if let lastToken = result.last?.asToken {
				// If we've already grabbed a token, remove it from the next non-match.
				let prefixToDrop: String
				if dropPrefix {
					prefixToDrop = lastToken
				} else {
					prefixToDrop = String(lastToken.dropFirst(prefix.count))
				}
				endOfLastMatchToEndOfString = endOfString.droppingPrefix(prefixToDrop)
			} else {
				endOfLastMatchToEndOfString = ""
			}
			result.append(.text(endOfLastMatchToEndOfString))
		}
		return result

	}
	
}
