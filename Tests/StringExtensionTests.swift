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
}
