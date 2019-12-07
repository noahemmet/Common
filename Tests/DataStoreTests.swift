//
//  DataStoreTests.swift
//  CommonTests
//
//  Created by Noah Emmet on 7/15/18.
//  Copyright © 2018 Sticks. All rights reserved.
//

import Foundation
import Common
import XCTest

class DataStoreTests: XCTestCase {
  var dataStore: DataStore!
  
  struct Bar: UniqueIdentifiable, Equatable {
    var id: Identifier<DataStoreTests.Bar>
    init(id: Identifier<DataStoreTests.Bar>) {
      self.id = id
    }
  }
  
  struct Foo: UniqueIdentifiable, Equatable {
    var id: Identifier<DataStoreTests.Foo>
    var string: String
    init(id: Identifier<DataStoreTests.Foo>, string: String) {
      self.id = id
      self.string = string
    }
  }
  
  override func setUp() {
    super.setUp()
    dataStore = DataStore(testClass: self)
  }
  
  override func tearDown() {
    dataStore = nil
    super.tearDown()
  }
  
//    func testSetAndGetValue() throws {
//        let bar = Bar()
//        dataStore.setValue(bar)
//        let returnedBar = try dataStore.value(for: bar.identifier)
//        XCTAssertEqual(bar, returnedBar)
//    }
//    
//    func testSetAndGetMultipleValues() throws {
//        let bar1 = Bar()
//        let bar2 = Bar()
//        let bars: Set<Bar> = [bar1, bar2]
//        dataStore.setValues(bars)
//        let returnedBars = try dataStore.allValues(ofType: Bar.self)
//        XCTAssertEqual(bars, returnedBars)
//    }
//    
//    func testUpdateValue() throws {
//        var foo = Foo(string: "initial")
//        var fooOld = foo
//        foo.string = "new"
//        dataStore.setValue(foo)
//        XCTAssertEqual(fooOld.string, "initial")
//        try fooOld.update(in: dataStore)
//        XCTAssertEqual(fooOld.string, "new")
//    }
}
