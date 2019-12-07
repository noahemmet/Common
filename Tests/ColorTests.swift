//
//  ColorTests.swift
//  Common
//
//  Created by Noah Emmet on 10/23/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation
import Common
import XCTest

class ColorTests: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testColors() throws {
    XCTAssertNoThrow(try Color(hex: "DDEDDE"))
//        let uiColor = color.uiColor
//        assert(color == uiColor.color.uiColor.color)
  }
}
