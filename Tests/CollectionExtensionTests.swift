import XCTest
import Common

class CollectionExtensionTests: XCTestCase {
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testFirstAsType() {
    struct One {}
    struct Two {}
    let array: [Any] = [One(), Two()]
    let one = array.first(as: One.self, where: { $0 as? One} )
    XCTAssertNotNil(one)
    let two = array.first(where: { $0 as? Two} )
    XCTAssertNotNil(two)
  }
}
