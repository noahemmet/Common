import XCTest
import Common

class BidirectionalCollectionExtensionTests: XCTestCase {
  override func setUp() {}

  override func tearDown() {}

  func testNeighbors() {
    let array = [1, 2, 3, 4, 5]
    XCTAssertEqual(array.neighbors(around: 1, loop: true), [5, 2])
    XCTAssertEqual(array.neighbors(around: 2, loop: true), [1, 3])
    XCTAssertEqual(array.neighbors(around: 5, loop: true), [4, 1])
  }
}
