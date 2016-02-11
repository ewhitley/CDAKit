//
//  C32ProcedureImporterTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Fuzi

class C32ProcedureImporterTest: XCTestCase {
  override func setUp() {
    super.setUp()
    TestHelpers.collections.providers.load_providers()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_procedure_importing() {
    
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("NISTExampleC32")
    var doc: XMLDocument!
    
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      let pi = HDSImport_C32_PatientImporter()
      let patient = pi.parse_c32(doc)
      
      let procedure0 = patient.procedures[0]
      XCTAssertTrue(procedure0.negation_ind == false) //check on this...
      XCTAssertTrue(procedure0.codes.containsCode("SNOMED-CT", withCode: "52734007"))
      XCTAssertEqual(procedure0.performer?.title, "Dr.")
      XCTAssertEqual(procedure0.performer?.family_name, "Kildare")
      XCTAssertTrue(procedure0.anatomical_target.containsCode("SNOMED-CT", withCode: "1234567"))

      let procedure1 = patient.procedures[1]
      XCTAssertTrue(procedure1.negation_ind == true)  // check on this, too...
      XCTAssertEqual("PATOBJ", procedure1.negation_reason.codes.first?.code)
      XCTAssertTrue(procedure1.codes.containsCode("SNOMED-CT", withCode: "52734007"))
      XCTAssertEqual(procedure1.performer?.title, "Dr.")
      XCTAssertEqual(procedure1.performer?.family_name, "Watson")
      XCTAssertTrue(procedure1.anatomical_target.containsCode("SNOMED-CT", withCode: "1234567"))
      
    } catch {
      print("boom")
    }
  }
    
}
