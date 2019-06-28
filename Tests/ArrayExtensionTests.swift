import XCTest
import Common

class ArrayExtensionTests: XCTestCase {
	
	override func setUp() {
	}
	
	override func tearDown() {
	}
	
	func testDropRandom() {
		let array = [1, 2, 3, 4, 5]
		let dropped = array.randomized(keep: 2)
		XCTAssertEqual(dropped.count, 2)
	}
}
