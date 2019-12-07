import XCTest
import Common

class ArrayExtensionTests: XCTestCase {
  override func setUp() {}
  
  override func tearDown() {}
  
  func testDropRandom() {
    let array = [1, 2, 3, 4, 5]
    let keep2 = array.randomized(keep: 2)
    XCTAssertEqual(keep2.count, 2)
    let keep3 = array.randomized(keep: 3)
    XCTAssertEqual(keep3.count, 3)
    let keep4 = array.randomized(keep: 4)
    XCTAssertEqual(keep4.count, 4)
  }
  
  func testDropRandomClamping() {
    let array = [1, 2]
    let dropped = array.randomized(keep: 3)
    XCTAssertEqual(dropped.count, 2)
  }
}
