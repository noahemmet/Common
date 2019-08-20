import XCTest
import Common

class StringExtensionTests: XCTestCase {
	
	override func setUp() {
	}
	
	override func tearDown() {
	}
	
	func testCamelCase() {
		let text = "one two three"
		XCTAssertEqual(text.lowerCamelCased, "oneTwoThree")
		XCTAssertEqual(text.upperCamelCased, "OneTwoThree")
		
		let empty = ""
		XCTAssertEqual(empty.lowerCamelCased, "")
	}
	
	func testMatches() throws {
		let string = "one two three four"
		let ranges = string.ranges(of: "two")
		let stringsAndRanges = string.strings(for: ranges)
		let matches = stringsAndRanges.map { $0.0 }
		let replaced: [Int] = try string.replacing(matches) { match, _ in
			switch match {
			case "one ": return 1
			case "two": return 2
			case " three four": return 34
			default: throw BasicError.reason("Unknown match: \(match)")
			}
		}
		XCTAssertEqual(replaced, [1, 2, 34])
	}
	
	func testTokenizeDroppingPrefix() throws { 
		let untilCharacterSet = CharacterSet.whitespaces.union(.punctuationCharacters)
		
		let string = "Hi, my name is @token; nice to meet ya. @token2."
		let tokens = string.tokenize(prefix: "@", untilAny: untilCharacterSet, dropPrefix: true)
		XCTAssertEqual(tokens[0].asText, "Hi, my name is ")
		XCTAssertEqual(tokens[1].asToken, "token")
		XCTAssertEqual(tokens[2].asText, "; nice to meet ya. ")
		XCTAssertEqual(tokens[3].asToken, "token2")
		XCTAssertEqual(tokens[4].asText, ".")
	}
	
	func testTokenizeNotDroppingPrefix() throws { 
		let string = "Hi, my name is @token; nice to meet ya. @token2."
		let tokens = string.tokenize(prefix: "@", untilAny: CharacterSet.whitespaces.union(.punctuationCharacters), dropPrefix: false)
		XCTAssertEqual(tokens[0].asText, "Hi, my name is ")
		XCTAssertEqual(tokens[1].asToken, "@token")
		XCTAssertEqual(tokens[2].asText, "; nice to meet ya. ")
		XCTAssertEqual(tokens[3].asToken, "@token2")
		XCTAssertEqual(tokens[4].asText, ".")
	}
	
	func testTokenizeJustTokenDroppingPrefix() throws { 
		let untilCharacterSet = CharacterSet.whitespaces.union(.punctuationCharacters)
		let string = "@token"
		let tokens = string.tokenize(prefix: "@", untilAny: untilCharacterSet, dropPrefix: true)
		XCTAssertEqual(tokens[0].asToken, "token")
	}
	
	func testTokenizeJustTokenNotDroppingPrefix() throws { 
		let untilCharacterSet = CharacterSet.whitespaces.union(.punctuationCharacters)
		let string = "@token"
		let tokens = string.tokenize(prefix: "@", untilAny: untilCharacterSet, dropPrefix: false)
		XCTAssertEqual(tokens[0].asToken, "@token")
	}
	
	func testTokenizeLeadingSpaceTokenNotDroppingPrefix() throws { 
		let untilCharacterSet = CharacterSet.whitespaces.union(.punctuationCharacters)
		let string = "foo @token"
		let tokens = string.tokenize(prefix: "@", untilAny: untilCharacterSet, dropPrefix: false)
		XCTAssertEqual(tokens[0].asText, "foo ")
		XCTAssertEqual(tokens[1].asToken, "@token")
	}
	
	func testTokenizePlainString() throws { 
		let string = "No tokens here."
		let tokensDroppingPrefix = string.tokenize(prefix: "@", untilAny: CharacterSet.whitespaces.union(.punctuationCharacters), dropPrefix: true)
		XCTAssertEqual(tokensDroppingPrefix[0].asText, "No tokens here.")
		
		let tokensNotDroppingPrefix = string.tokenize(prefix: "@", untilAny: CharacterSet.whitespaces.union(.punctuationCharacters), dropPrefix: false)
		XCTAssertEqual(tokensNotDroppingPrefix[0].asText, "No tokens here.")
	}
}
