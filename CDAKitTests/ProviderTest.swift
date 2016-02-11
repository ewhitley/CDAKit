//
//  HDSProviderTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/10/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit


class HDSProviderTest: XCTestCase {
    
  override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }
  
  func test_valid_npi_value() {
    XCTAssertEqual("3", HDSProvider.luhn_checksum("7992739871"))
    XCTAssert(HDSProvider.valid_npi("1234567893"))
    XCTAssert(HDSProvider.valid_npi("808401234567893"))
    XCTAssertEqual(false, HDSProvider.valid_npi("1"))
    XCTAssertEqual(false, HDSProvider.valid_npi("1010101010"))
    XCTAssertEqual(false, HDSProvider.valid_npi("abcdefghij"))
  }

  func test_npi_assignment() {
    //# A provider should only have a single NPI
    let p = HDSProvider()
    p.npi = "1234567893"
    XCTAssertEqual(1, p.cda_identifiers.count)
//    assert_equal 1, p.cda_identifiers.length
    
    p.npi = "808401234567893"
    XCTAssertEqual(1, p.cda_identifiers.count)
//    assert_equal 1, p.cda_identifiers.length
    
    XCTAssertEqual("808401234567893", p.npi)
    
  }

  
}
