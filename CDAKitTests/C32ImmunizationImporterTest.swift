//
//  C32ImmunizationImporterTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Fuzi

class C32ImmunizationImporterTest: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    CDAKGlobals.sharedInstance.CDAKProviders.removeAll()
    TestHelpers.collections.providers.load_providers()
    
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_immunization_importing() {
    
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("NISTExampleC32")
    var doc: XMLDocument!
    
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      let pi = CDAKImport_C32_PatientImporter()
      let patient = pi.parse_c32(doc)
      
      let immunization0 = patient.immunizations[0]
      
      XCTAssertEqual(immunization0.codes.containsCode("CVX", withCode: "88"), true)
      XCTAssertEqual(immunization0.codes.containsCode("CVX", withCode: "111"), true)

      let immunization1 = patient.immunizations[1]
      XCTAssertEqual(immunization1.refusal_ind, false)

      let immunization3 = patient.immunizations[3]
      XCTAssertEqual(immunization3.refusal_ind, true)
      XCTAssertEqual("PATOBJ", immunization3.refusal_reason.codes.first?.code)
      XCTAssertEqual(immunization3.refusal_ind, true)
      XCTAssertEqual("PATOBJ", immunization3.negation_reason.codes.first?.code)

      XCTAssertEqual(immunization3.performer?.given_name, "FirstName")
      XCTAssertEqual(immunization3.performer?.addresses.first?.street.first, "100 Bureau Drive")
      
    } catch {
      print("boom")
    }
    
  }
    
}
