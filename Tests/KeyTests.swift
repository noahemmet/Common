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

    func testKeyInit() {
        let key1 = Key("lowerUpper")
        XCTAssertEqual(key1.rawValue, "lowerUpper")
        let key2 = Key(rawValue: "lowerUpper")
        XCTAssertEqual(key2.rawValue, "lowerUpper")
        let key3 = Key(rawValue: "lower Upper")
        XCTAssertEqual(key3.rawValue, "lowerUpper")
        let key4 = Key(rawValue: "Upper Upper")
        XCTAssertEqual(key4.rawValue, "upperUpper")
        let key5 = Key(rawValue: "lower lower")
        XCTAssertEqual(key5.rawValue, "lowerLower")
    }
}
