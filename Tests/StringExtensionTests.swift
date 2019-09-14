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
    
    func testSnakeCase() {
        let text = "one two three"
        XCTAssertEqual(text.lowerSnakeCased, "one_two_three")
        
        let empty = ""
        XCTAssertEqual(empty.lowerSnakeCased, "")
    }
}
