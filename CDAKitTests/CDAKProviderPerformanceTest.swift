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
  
  func testProviderPerformanceImport_Emerge673() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Patient-673")
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      //print("providers: \(record.provider_performances)")
      //print(record.json)
      //print(record.export(inFormat: .ccda))
    print(record.export(inFormat: .c32))
    }
    catch {
      XCTFail()
    }
  }

  func testProviderPerformanceImport_HL7CCDSample() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("HL7CCD.sample")
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
//      print("providers: \(record.provider_performances)")
//      print(record.json)
      
//      print(record.json)
      
//      print("record.allergies: \(record.allergies)")
      //print("record.allergies: \(record.allergies)")
      
//      print(record.export(inFormat: .c32))
      
      //record.medications[0].dose_restriction.numerator = CDAKValueAndUnit(value: 1.0, unit: "mg")
      //record.medications[0].dose_restriction.denominator = CDAKValueAndUnit(value: 2.0, unit: "cm")
      
      
      print(record.export(inFormat: .ccda))
      
//      print("record.social_history.count = \(record.social_history.count)")

//      print(record.advance_directives.map({$0.json}))
//      for entry in record.medical_equipment {
//        print(entry.json)
//      }
      
//      print(CDAKGlobals.sharedInstance.allProviders)
//      print("medication performers: \(record.medications)) ")
      
      //print(record.export(inFormat: .ccda))
    }
    catch {
      XCTFail()
    }
  }

  
  
}
