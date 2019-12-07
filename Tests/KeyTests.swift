//
//  KeyTests.swift
//  CommonTests
//
//  Created by Noah Emmet on 2/6/19.
//  Copyright © 2019 Sticks. All rights reserved.
//

import XCTest
import Common

class KeyTests: XCTestCase {
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  //	func testKeyCamelInit() {
  //		let key1 = Key("lowerUpper")
  //		XCTAssertEqual(key1.rawValue, "lowerUpper")
  //		let key2 = Key("lowerUpper")
  //		XCTAssertEqual(key2.rawValue, "lowerUpper")
  //		let key3 = Key("lower Upper")
  //		XCTAssertEqual(key3.rawValue, "lowerUpper")
  //		let key4 = Key("Upper Upper")
  //		XCTAssertEqual(key4.rawValue, "upperUpper")
  //		let key5 = Key("lower lower")
  //		XCTAssertEqual(key5.rawValue, "lowerLower")
//
  //		let key6 = Key(rawValue: "raw value")
  //		XCTAssertEqual(key6.rawValue, "raw value")
  //	}
  
  func testKeySnakeInit() {
    let key1 = Key("lower Upper")
    XCTAssertEqual(key1.rawValue, "lower_upper")
  }
  
  func testKeyedCollection() {
    struct Foo: Keyed, Equatable {
      var key: Key
    }
    let arr: [Foo] = [Foo(key: "1"), Foo(key: "2"), Foo(key: "3")]
    let keys: [Key] = ["1", "3"]
    let filtered: [Foo] = arr.from(keys)
    XCTAssertEqual(filtered, [Foo(key: "1"), Foo(key: "3")])
  }
}
