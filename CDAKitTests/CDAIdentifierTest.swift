//
//  HDSCDAIdentifierTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/9/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit


class HDSCDAIdentifierTest: XCTestCase {
    
  override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }
  
  func test_equality() {
    let id1 = HDSCDAIdentifier(root: "1.2.3.4", extension_id: "abcdef")
    let id2 = HDSCDAIdentifier(root: "1.2.3.4", extension_id: "abcdef")
    let id3 = HDSCDAIdentifier(root: "dfadsfdsaf")
    let id4 = HDSCDAIdentifier(root: "1.2.3.4", extension_id: "abasdsadcdef")

    //let x = id1.as_string

    XCTAssertEqual(id1, id2)
    XCTAssertFalse(id1 == id3)
    XCTAssertFalse(id1 == id4)
    XCTAssertFalse(id1.as_string == "foo")
    
  }
    
  
}
