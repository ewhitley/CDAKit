//
//  CDAKitTests.swift
//  CDAKitTests
//
//  Created by Eric Whitley on 2/11/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

class CDAKitNonStandardCDATests: XCTestCase {
    
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }

  func testNonStandardCDAImport() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("170.314(b)(1)InPt_Discharge Summary CED Type")

    //try enabling "non-standard" support
    // CDA Template ID: 2.16.840.1.113883.10.20.22.1.1 is found, but this is ONLY the general header
    CDAKGlobals.sharedInstance.attemptNonStandardCDAImport = true
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      print(record)
    }
    catch {
      XCTFail()
    }

    //let's try importing, but with the "non-standard" support disabled
    CDAKGlobals.sharedInstance.attemptNonStandardCDAImport = false
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      XCTFail()
    }
    catch {
    }

  }
    
}
