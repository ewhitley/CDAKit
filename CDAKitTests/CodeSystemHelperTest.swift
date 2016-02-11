//
//  CodeSystemHelperTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/17/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit


class CodeSystemHelperTest: XCTestCase {
    
  override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }
  
  func test_oid_lookup() {
    XCTAssertEqual(HDSCodeSystemHelper.code_system_for("2.16.840.1.113883.6.88"), "RxNorm")
    XCTAssertEqual(HDSCodeSystemHelper.code_system_for("2.16.840.1.113883.6.59"), "CVX")
    XCTAssertEqual(HDSCodeSystemHelper.code_system_for("2.16.840.1.113883.12.292"), "CVX")
  }
  func test_name_lookup() {
    XCTAssertEqual(HDSCodeSystemHelper.oid_for_code_system("RxNorm"), "2.16.840.1.113883.6.88")
    XCTAssertEqual(HDSCodeSystemHelper.oid_for_code_system("CVX"), "2.16.840.1.113883.12.292")
    XCTAssertEqual(HDSCodeSystemHelper.oid_for_code_system("NCI Thesaurus"), "2.16.840.1.113883.3.26.1.1")
    XCTAssertEqual(HDSCodeSystemHelper.oid_for_code_system("FDA SPL"), "2.16.840.1.113883.3.26.1.1")
  }

  
}
