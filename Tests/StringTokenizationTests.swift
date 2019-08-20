import XCTest
import Common

class StringTokenizationTests: XCTestCase {
	
	override func setUp() {
	}
	
	override func tearDown() {
	}
	
	// MARK: - CharacterSetPrefix
	
	func testTokenizeCharacterSetDroppingPrefix() throws { 
		let untilCharacterSet = CharacterSet.whitespaces.union(.punctuationCharacters)
		
		let string = "Hi, my name is @token; nice to meet ya. @token2."
		let tokens = string.tokenize(prefix: "@", untilAny: untilCharacterSet, dropPrefix: true)
		XCTAssertEqual(tokens[0].asText, "Hi, my name is ")
		XCTAssertEqual(tokens[1].asToken, "token")
		XCTAssertEqual(tokens[2].asText, "; nice to meet ya. ")
		XCTAssertEqual(tokens[3].asToken, "token2")
		XCTAssertEqual(tokens[4].asText, ".")
	}
	
	func testTokenizeCharacterSetNotDroppingPrefix() throws { 
		let string = "Hi, my name is @token; nice to meet ya. @token2."
		let tokens = string.tokenize(prefix: "@", untilAny: CharacterSet.whitespaces.union(.punctuationCharacters), dropPrefix: false)
		XCTAssertEqual(tokens[0].asText, "Hi, my name is ")
		XCTAssertEqual(tokens[1].asToken, "@token")
		XCTAssertEqual(tokens[2].asText, "; nice to meet ya. ")
		XCTAssertEqual(tokens[3].asToken, "@token2")
		XCTAssertEqual(tokens[4].asText, ".")
	}
	
	func testTokenizeCharacterSetJustTokenDroppingPrefix() throws { 
		let untilCharacterSet = CharacterSet.whitespaces.union(.punctuationCharacters)
		let string = "@token"
		let tokens = string.tokenize(prefix: "@", untilAny: untilCharacterSet, dropPrefix: true)
		XCTAssertEqual(tokens[0].asToken, "token")
	}
	
	func testTokenizeCharacterSetJustTokenNotDroppingPrefix() throws { 
		let untilCharacterSet = CharacterSet.whitespaces.union(.punctuationCharacters)
		let string = "@token"
		let tokens = string.tokenize(prefix: "@", untilAny: untilCharacterSet, dropPrefix: false)
		XCTAssertEqual(tokens[0].asToken, "@token")
	}
	
	func testTokenizeCharacterSetLeadingSpaceTokenNotDroppingPrefix() throws { 
		let untilCharacterSet = CharacterSet.whitespaces.union(.punctuationCharacters)
		let string = "foo @token"
		let tokens = string.tokenize(prefix: "@", untilAny: untilCharacterSet, dropPrefix: false)
		XCTAssertEqual(tokens[0].asText, "foo ")
		XCTAssertEqual(tokens[1].asToken, "@token")
	}
	
	func testTokenizeCharacterSetPlainString() throws { 
		let string = "No tokens here."
		let tokensDroppingPrefix = string.tokenize(prefix: "@", untilAny: CharacterSet.whitespaces.union(.punctuationCharacters), dropPrefix: true)
		XCTAssertEqual(tokensDroppingPrefix[0].asText, "No tokens here.")
		
		let tokensNotDroppingPrefix = string.tokenize(prefix: "@", untilAny: CharacterSet.whitespaces.union(.punctuationCharacters), dropPrefix: false)
		XCTAssertEqual(tokensNotDroppingPrefix[0].asText, "No tokens here.")
	}
	
	// MARK: - StringPrefix
	
	func testTokenizeString() throws { 		
		let string = "Hi, my name is @{token}; nice to meet ya. @{token2}."
		let tokens = string.tokenize(prefix: "@{", until: "}")
		XCTAssertEqual(tokens[0].asText, "Hi, my name is ")
		XCTAssertEqual(tokens[1].asToken, "token")
		XCTAssertEqual(tokens[2].asText, "; nice to meet ya. ")
		XCTAssertEqual(tokens[3].asToken, "token2")
		XCTAssertEqual(tokens[4].asText, ".")
	}
	
	
	func testTokenizeStringJustToken() throws { 
		let string = "@{token}"
		let tokens = string.tokenize(prefix: "@{", until: "}")
		XCTAssertEqual(tokens[0].asToken, "token")
	}
	
	
	func testTokenizeStringLeadingSpaceToken() throws { 
		let string = "foo {@token}"
		let tokens = string.tokenize(prefix: "@{", until: "}")
		XCTAssertEqual(tokens[0].asText, "foo ")
		XCTAssertEqual(tokens[1].asToken, "token")
	}
	
	func testTokenizeStringPlainString() throws { 
		let string = "No tokens here."
		let tokens = string.tokenize(prefix: "@{", until: "}")
		XCTAssertEqual(tokens[0].asText, "No tokens here.")
		
	}
}
