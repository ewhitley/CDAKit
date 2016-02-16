//
//  C32HDSConditionImporterTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Fuzi

class C32HDSConditionImporterTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
      let pi = CDAKImport_C32_PatientImporter()
      let patient = pi.parse_c32(doc)

      let condition = patient.conditions[0]
      
      XCTAssertEqual("CDAKCondition", condition.type)
      XCTAssertEqual(false, condition.cause_of_death)
      XCTAssertEqual(condition.codes.containsCode("SNOMED-CT", withCode: "195967001"), true)

      XCTAssertEqual(condition.start_time, HL7Helper.timestamp_to_integer("19500101000000"))

      XCTAssertEqual(1, condition.priority)
      XCTAssertEqual(condition.ordinality.codeSystems.contains("SNOMED-CT"), true)
      XCTAssertEqual(condition.ordinality.containsCode("SNOMED-CT", withCode: "8319008"), true)

      
    } catch {
      print("boom")
    }
    
  }
  
}
