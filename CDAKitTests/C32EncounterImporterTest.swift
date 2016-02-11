//
//  C32EncounterImporterTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Fuzi

class C32EncounterImporterTest: XCTestCase {
    
  override func setUp() {
      super.setUp()

    TestHelpers.collections.providers.load_providers()
    
  }
  
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }
    
  func test_condition_importing() {
    
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("NISTExampleC32")
    var doc: XMLDocument!
    
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      let pi = HDSImport_C32_PatientImporter()
      let patient = pi.parse_c32(doc)
      
      let encounter = patient.encounters[0]
      XCTAssertEqual(encounter.codes.containsCode("CPT", withCode: "99241"), true)
      XCTAssertEqual(encounter.performer?.title, "Dr.")
      XCTAssertEqual(encounter.performer?.family_name, "Kildare")
      XCTAssertEqual(encounter.facility?.name, "Good Health Clinic")
      XCTAssertEqual(encounter.reason?.codes.containsCode("SNOMED-CT", withCode: "308292007"), true)

      XCTAssertEqual(encounter.admit_type.containsCode("CPT", withCode: "xyzzy"), true)
      XCTAssertEqual(encounter.facility?.codes.codeSystems.contains("HL7 Healthcare Service Location"), true)
      
      XCTAssertEqual(encounter.facility?.start_time, HL7Helper.timestamp_to_integer("20000407000000"))

      XCTAssertEqual(encounter.facility?.codes.containsCode("HL7 Healthcare Service Location", withCode: "1117-1"), true)

      
    } catch {
      print("boom")
    }
    
  }
}
