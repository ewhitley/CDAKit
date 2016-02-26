//
//  CDAKProviderPerformanceTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/26/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import HealthKit
import Fuzi

class CDAKProviderPerformanceTest: XCTestCase {
    
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testProviderPerformanceImport() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Patient-673")
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      print("providers: \(record.provider_performances)")
      print(record.export(inFormat: .ccda))
    }
    catch {
      XCTFail()
    }
  }
  
  
}
