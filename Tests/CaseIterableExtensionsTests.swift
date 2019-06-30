import XCTest
import Common

class CaseIterableExtensionTests: XCTestCase {
	
	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testOther() {
		enum Foo: String, CaseIterable { case bar, baz }
		for _ in 0..<20 {
			let a = Foo.bar
			let b = a.other
			XCTAssertEqual(b, Foo.baz)
		}
	}
	
	func testNext() {
		enum Foo: String, CaseIterable { case one, two }
		let one = Foo.one
		let two = one.next
		XCTAssertEqual(two, Foo.two)
		let oneAgain = two.next
		XCTAssertEqual(oneAgain, Foo.one)
	}
}
