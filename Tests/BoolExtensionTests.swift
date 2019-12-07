import XCTest
import Common

class BoolExtensionTests: XCTestCase {
  override func setUp() {}
  
  override func tearDown() {}
  
  func testOptionalBool() {
    let boolTrue: Bool? = true
    let boolFalse: Bool? = false
    let boolNil: Bool? = nil
    XCTAssertTrue(boolTrue.isTrueOrNil)
    XCTAssertFalse(boolFalse.isTrueOrNil)
    XCTAssertTrue(boolNil.isTrueOrNil)
  }
}
