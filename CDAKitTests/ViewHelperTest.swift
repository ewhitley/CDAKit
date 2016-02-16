//
//  ViewHelperTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/18/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit


class ViewHelperTest: XCTestCase {
    
  override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }
  
  func test_code_display() {
    
    let fields: [String:Any?] = [
      "description" : "bacon > cheese",
      "time" : 1234,
      "codes" : ["CPT" : ["1234"]]
    ]
    let entry = CDAKEntry(event: fields)
    print("codes = \(entry.codes)")
    let code_xml = ViewHelper.code_display(entry)
    print("code_xml = \n\n\(code_xml)\n\n")

    XCTAssert(!code_xml.containsString("bacon > cheese"))
    XCTAssert(code_xml.containsString("bacon &gt; cheese"))
    XCTAssertEqual(code_xml, "<code nullFlavor=\"UNK\" ><originalText>bacon &gt; cheese</originalText><translation code=\"1234\" codeSystem=\"2.16.840.1.113883.6.12\"/>\n</code>")
    
  }
  
  func test_time_if_not_nil() {
    XCTAssertNil(ViewHelper.time_if_not_nil(nil))
    XCTAssertNil(ViewHelper.time_if_not_nil(nil, nil))
    XCTAssertNotNil(ViewHelper.time_if_not_nil(nil, 7))
    XCTAssertNotNil(ViewHelper.time_if_not_nil(7))
    XCTAssertEqual(NSDate(timeIntervalSince1970: 7), ViewHelper.time_if_not_nil(nil, 7))
    XCTAssertEqual(NSDate(timeIntervalSince1970: 7), ViewHelper.time_if_not_nil(7))
    XCTAssertEqual(NSDate(timeIntervalSince1970: 7), ViewHelper.time_if_not_nil(7, 8))
  }
    
}
