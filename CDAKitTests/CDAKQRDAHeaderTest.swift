//
//  CDAKQRDAHeaderTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
import Fuzi
@testable import CDAKit


class CDAKQRDAHeaderTest: XCTestCase {
    
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testHeaderImportRosaC32() {
    //NISTExampleC32
    //Patient-673
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Patient-673")
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      print(record.json)
//      if let header = record.cdaHeader {
//        let info = header.json
//        print("HEADER : \(info)")
//      } else {
//        print("NO HEADER")
//      }
    }
    catch {
      XCTFail()
    }

    
  }
  
}
