import XCTest
import Common

class StringExtensionTests: XCTestCase {
	
	override func setUp() {
	}
	
	override func tearDown() {
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
	
	func testTokenize() throws { 
		let string = "Hi, my name is @token; nice to meet ya. @token2."
		let tokens = string.tokenize(prefix: "@", until: CharacterSet.whitespaces.union(.punctuationCharacters))
		XCTAssertEqual(<#T##expression1: Equatable##Equatable#>, <#T##expression2: Equatable##Equatable#>)
		print(m)
		print("")
	}
}

extension String {
	func split(byPrefix prefix: String, to endCharacterSet: CharacterSet) -> [WordSplitResult] {
		
		return []
	}
}
