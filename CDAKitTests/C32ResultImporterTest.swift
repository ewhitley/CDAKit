//
//  C32ResultImporterTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Fuzi

class C32ResultImporterTest: XCTestCase {
    
  override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }

  func test_result_importing() {
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("NISTExampleC32")
    var doc: XMLDocument!
    
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      let pi = HDSImport_C32_PatientImporter()
      let patient = pi.parse_c32(doc)
      
      
      let result = patient.results[0]
      XCTAssertEqual("N", result.interpretation.codes.first?.code)
      XCTAssertEqual("HITSP C80 Observation Status", result.interpretation.codes.first?.codeSystem)
      XCTAssertEqual("M 13-18 g/dl; F 12-16 g/dl", result.reference_range)
      XCTAssertEqual("HGB (M 13-18 g/dl; F 12-16 g/dl)", result.item_description)
      
    } catch {
      print("boom")
    }
  }
    
}
