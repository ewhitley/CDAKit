//
//  CDAKCodedEntriesTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 3/1/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit


class CDAKCodedEntriesTest: XCTestCase {
    
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
    
  func testExample() {
    var ces = CDAKCodedEntries()
    ces.preferred_code_sets = ["SNOMED-CT"]
    ces.addCodes("LOINC", code: "2", displayName: "LOINC-2")
    ces.addCodes("LOINC", code: "1", displayName: "LOINC-1")
    ces.addCodes("SNOMED-CT", code: "3", displayName: "SNOMED-2")
    ces.addCodes("CPT", code: "4", displayName: "CPT-4")
    XCTAssertEqual(4, ces.codes.count)
    XCTAssertNotNil(ces.preferred_code)
    XCTAssertEqual(3, ces.translation_codes.count)
    
    var ces2 = CDAKCodedEntries()
    ces2.preferred_code_sets = ["LOINC"]
    ces2.addCodes("LOINC", code: "2", displayName: "LOINC-2")
    ces2.addCodes("LOINC", code: "1", displayName: "LOINC-1")
    ces2.addCodes("SNOMED-CT", code: "3", displayName: "SNOMED-2")
    ces2.addCodes("CPT", code: "4", displayName: "CPT-4")
    XCTAssertEqual(4, ces2.codes.count)
    XCTAssertNotNil(ces2.preferred_code)
    XCTAssertEqual("1", ces2.preferred_code?.code)
    XCTAssertEqual(3, ces2.translation_codes.count)
    print("ces2.preferred_code = \(ces2.preferred_code)")
    print("ces2.translation_codes = \(ces2.translation_codes)")
    
    var ces3 = CDAKCodedEntries()
    //NOTE: not setting a preferred code set, so _everything_ is a translation
    ces3.addCodes("LOINC", code: "2", displayName: "LOINC-2")
    ces3.addCodes("LOINC", code: "1", displayName: "LOINC-1")
    ces3.addCodes("SNOMED-CT", code: "3", displayName: "SNOMED-2")
    ces3.addCodes("CPT", code: "4", displayName: "CPT-4")
    XCTAssertEqual(4, ces2.codes.count)
    XCTAssertNil(ces3.preferred_code)//NIL assert
    XCTAssertEqual(4, ces3.translation_codes.count)
    print("ces3.preferred_code = \(ces3.preferred_code)")
    print("ces3.translation_codes = \(ces3.translation_codes)")
    
  }
  
  
}
